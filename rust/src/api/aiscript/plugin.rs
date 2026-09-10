// クライアントプラグインの実行環境。
//
// 本家 Misskey の `packages/frontend/src/plugin.ts` に対応する。aria には
// この機能がないので、本家の Vue 実装を読んで組んだ。
//
// SPDX-FileCopyrightText: syuilo and misskey-project, miria contributors
// SPDX-License-Identifier: AGPL-3.0-only

use std::{
    collections::HashMap,
    sync::{Arc, Mutex},
};

use aiscript::{v0, v1};
use flutter_rust_bridge::DartFnFuture;
use futures::{FutureExt, future::BoxFuture};

/// `note_action` / `user_action` のハンドラ。
///
/// 対象 (ノートやユーザー) を JSON で渡して呼ぶ。戻り値は使わない。
pub struct PluginActionCallback(
    Arc<dyn Fn(String) -> BoxFuture<'static, Result<(), String>> + Sync + Send + 'static>,
);

impl PluginActionCallback {
    pub async fn call(&self, value: String) -> Result<(), String> {
        self.0(value).await
    }
}

/// `*_view_interruptor` / `note_post_interruptor` のハンドラ。
///
/// 対象を JSON で渡すと、書き換わったものが JSON で返る。
pub struct PluginInterruptorCallback(
    Arc<dyn Fn(String) -> BoxFuture<'static, Result<String, String>> + Sync + Send + 'static>,
);

impl PluginInterruptorCallback {
    pub async fn call(&self, value: String) -> Result<String, String> {
        self.0(value).await
    }
}

/// `post_form_action` のハンドラ。
///
/// 本家はハンドラに (フォーム, update関数) を渡し、プラグインが update を
/// 好きなだけ呼んでフォームを書き換える。ここでは呼ばれた update を集めて、
/// 変更点だけを JSON オブジェクトにして返す。ハンドラの実行中に呼ばれた
/// ぶんだけが対象で、実行後に非同期で呼ばれたものは拾えない。
pub struct PluginPostFormActionCallback(
    Arc<dyn Fn(String) -> BoxFuture<'static, Result<String, String>> + Sync + Send + 'static>,
);

impl PluginPostFormActionCallback {
    pub async fn call(&self, form: String) -> Result<String, String> {
        self.0(form).await
    }
}

pub type OnActionCallback = dyn Fn(String, String, PluginActionCallback) -> DartFnFuture<()>
    + Sync
    + Send
    + 'static;

pub type OnPostFormActionCallback = dyn Fn(String, PluginPostFormActionCallback) -> DartFnFuture<()>
    + Sync
    + Send
    + 'static;

pub type OnInterruptorCallback =
    dyn Fn(String, PluginInterruptorCallback) -> DartFnFuture<()> + Sync + Send + 'static;

/// プラグインが使える `Plugin:*`。
#[derive(Clone)]
pub struct AsPluginLib {
    /// `Plugin:config` に入れる値。JSON オブジェクト。
    config: String,
    open_url: Arc<dyn Fn(String) -> DartFnFuture<()> + Sync + Send + 'static>,
    /// 登録されたのが `note_action` か `user_action` かを第1引数で渡す。
    on_action: Arc<OnActionCallback>,
    on_post_form_action: Arc<OnPostFormActionCallback>,
    /// 第1引数は `note_view` / `note_post` / `page_view` のいずれか。
    on_interruptor: Arc<OnInterruptorCallback>,
}

impl AsPluginLib {
    #[flutter_rust_bridge::frb(sync)]
    pub fn new(
        config: String,
        open_url: impl Fn(String) -> DartFnFuture<()> + Sync + Send + 'static,
        on_action: impl Fn(String, String, PluginActionCallback) -> DartFnFuture<()>
        + Sync
        + Send
        + 'static,
        on_post_form_action: impl Fn(String, PluginPostFormActionCallback) -> DartFnFuture<()>
        + Sync
        + Send
        + 'static,
        on_interruptor: impl Fn(String, PluginInterruptorCallback) -> DartFnFuture<()>
        + Sync
        + Send
        + 'static,
    ) -> Self {
        AsPluginLib {
            config,
            open_url: Arc::new(open_url),
            on_action: Arc::new(on_action),
            on_post_form_action: Arc::new(on_post_form_action),
            on_interruptor: Arc::new(on_interruptor),
        }
    }
}

/// `Plugin:*` の登録。v0 と v1 で型の道だけが違うので、マクロで畳む。
macro_rules! impl_register {
    ($method:ident, $v:ident) => {
        impl AsPluginLib {
            pub(super) fn $method(&self, consts: &mut HashMap<String, $v::values::Value>) {
                use $v::{errors::AiScriptError, values};

                consts.insert(
                    "Plugin:config".to_string(),
                    serde_json::from_str(&self.config).map_or_else(
                        |_| values::Value::obj(Vec::<(String, values::Value)>::new()),
                        values::Value::new,
                    ),
                );

                consts.insert(
                    "Plugin:open_url".to_string(),
                    values::Value::fn_native({
                        let open_url = self.open_url.clone();
                        move |args, _| {
                            let open_url = open_url.clone();
                            let url = String::try_from(args.into_iter().next().unwrap_or_default());
                            async move {
                                open_url(url?).await;
                                Ok(values::Value::null())
                            }
                            .boxed()
                        }
                    }),
                );

                // ノート/ユーザーのメニューに項目を生やすもの
                for (name, kind) in [
                    ("Plugin:register:note_action", "note"),
                    ("Plugin:register:user_action", "user"),
                ] {
                    consts.insert(
                        name.to_string(),
                        values::Value::fn_native({
                            let on_action = self.on_action.clone();
                            let kind = kind.to_string();
                            move |args, interpreter| {
                                let on_action = on_action.clone();
                                let kind = kind.clone();
                                let interpreter = interpreter.clone();
                                let mut args = args.into_iter();
                                let parsed = String::try_from(args.next().unwrap_or_default())
                                    .and_then(|title| {
                                        let handler =
                                            values::VFn::try_from(args.next().unwrap_or_default())?;
                                        Ok((title, handler))
                                    });
                                async move {
                                    let (title, handler) = parsed?;
                                    let callback =
                                        PluginActionCallback(Arc::new(move |json: String| {
                                            let interpreter = interpreter.clone();
                                            let handler = handler.clone();
                                            async move {
                                                let value = values::Value::new(
                                                    serde_json::from_str(&json)
                                                        .map_err(|err| err.to_string())?,
                                                );
                                                interpreter
                                                    .exec_fn(handler, [value])
                                                    .await
                                                    .map_err(|err| err.to_string())?;
                                                Ok(())
                                            }
                                            .boxed()
                                        }));
                                    on_action(kind, title, callback).await;
                                    Ok(values::Value::null())
                                }
                                .boxed()
                            }
                        }),
                    );
                }

                // 表示や投稿の内容を書き換えるもの
                for (name, kind) in [
                    ("Plugin:register:note_view_interruptor", "note_view"),
                    ("Plugin:register:note_post_interruptor", "note_post"),
                    ("Plugin:register:page_view_interruptor", "page_view"),
                ] {
                    consts.insert(
                        name.to_string(),
                        values::Value::fn_native({
                            let on_interruptor = self.on_interruptor.clone();
                            let kind = kind.to_string();
                            move |args, interpreter| {
                                let on_interruptor = on_interruptor.clone();
                                let kind = kind.clone();
                                let interpreter = interpreter.clone();
                                let handler =
                                    values::VFn::try_from(args.into_iter().next().unwrap_or_default());
                                async move {
                                    let handler = handler?;
                                    let callback =
                                        PluginInterruptorCallback(Arc::new(move |json: String| {
                                            let interpreter = interpreter.clone();
                                            let handler = handler.clone();
                                            async move {
                                                let value = values::Value::new(
                                                    serde_json::from_str(&json)
                                                        .map_err(|err| err.to_string())?,
                                                );
                                                let result = interpreter
                                                    .exec_fn(handler, [value])
                                                    .await
                                                    .map_err(|err| err.to_string())?;
                                                serde_json::to_string(&result.value)
                                                    .map_err(|err| err.to_string())
                                            }
                                            .boxed()
                                        }));
                                    on_interruptor(kind, callback).await;
                                    Ok(values::Value::null())
                                }
                                .boxed()
                            }
                        }),
                    );
                }

                consts.insert(
                    "Plugin:register:post_form_action".to_string(),
                    values::Value::fn_native({
                        let on_post_form_action = self.on_post_form_action.clone();
                        move |args, interpreter| {
                            let on_post_form_action = on_post_form_action.clone();
                            let interpreter = interpreter.clone();
                            let mut args = args.into_iter();
                            let parsed = String::try_from(args.next().unwrap_or_default()).and_then(
                                |title| {
                                    let handler =
                                        values::VFn::try_from(args.next().unwrap_or_default())?;
                                    Ok((title, handler))
                                },
                            );
                            async move {
                                let (title, handler) = parsed?;
                                let callback =
                                    PluginPostFormActionCallback(Arc::new(move |json: String| {
                                        let interpreter = interpreter.clone();
                                        let handler = handler.clone();
                                        async move {
                                            let form = values::Value::new(
                                                serde_json::from_str(&json)
                                                    .map_err(|err| err.to_string())?,
                                            );
                                            let updates = Arc::new(Mutex::new(
                                                serde_json::Map::<String, serde_json::Value>::new(),
                                            ));
                                            let update = values::Value::fn_native({
                                                let updates = updates.clone();
                                                move |args, _| {
                                                    let updates = updates.clone();
                                                    let mut args = args.into_iter();
                                                    let parsed = String::try_from(
                                                        args.next().unwrap_or_default(),
                                                    )
                                                    .map(|key| (key, args.next()));
                                                    async move {
                                                        let (key, value) = parsed?;
                                                        if let (Some(value), Ok(mut updates)) =
                                                            (value, updates.lock())
                                                        {
                                                            updates.insert(
                                                                key,
                                                                serde_json::to_value(&value.value)
                                                                    .map_err(
                                                                        AiScriptError::internal,
                                                                    )?,
                                                            );
                                                        }
                                                        Ok(values::Value::null())
                                                    }
                                                    .boxed()
                                                }
                                            });
                                            interpreter
                                                .exec_fn(handler, [form, update])
                                                .await
                                                .map_err(|err| err.to_string())?;
                                            let updates = updates
                                                .lock()
                                                .map_err(|err| err.to_string())?
                                                .clone();
                                            serde_json::to_string(&updates)
                                                .map_err(|err| err.to_string())
                                        }
                                        .boxed()
                                    }));
                                on_post_form_action(title, callback).await;
                                Ok(values::Value::null())
                            }
                            .boxed()
                        }
                    }),
                );

                // 後方互換。本家も `:` 版の別名として同じものを置いている
                for (old, new) in [
                    ("Plugin:register_note_action", "Plugin:register:note_action"),
                    ("Plugin:register_user_action", "Plugin:register:user_action"),
                    (
                        "Plugin:register_post_form_action",
                        "Plugin:register:post_form_action",
                    ),
                    (
                        "Plugin:register_note_view_interruptor",
                        "Plugin:register:note_view_interruptor",
                    ),
                    (
                        "Plugin:register_note_post_interruptor",
                        "Plugin:register:note_post_interruptor",
                    ),
                    (
                        "Plugin:register_page_view_interruptor",
                        "Plugin:register:page_view_interruptor",
                    ),
                ] {
                    if let Some(value) = consts.get(new).cloned() {
                        consts.insert(old.to_string(), value);
                    }
                }
            }
        }
    };
}

impl_register!(register_v0, v0);
impl_register!(register_v1, v1);

/// スクリプト冒頭のメタデータブロックを読む。
///
/// 本家の `parsePluginMeta` に対応する。名前なしのメタデータ (`### { ... }`)
/// を JSON にして返す。プラグインの名前やバージョンはここに入っている。
pub async fn parse_plugin_meta(input: String) -> Result<String, String> {
    fn meta_of<T>(
        meta: indexmap::IndexMap<Option<String>, Option<T>>,
    ) -> Result<T, String> {
        meta.into_iter()
            .find(|(name, _)| name.is_none())
            .and_then(|(_, value)| value)
            .ok_or_else(|| String::from("Metadata not found"))
    }

    if let Ok(script) = v1::Parser::default().parse(&input) {
        let meta = meta_of(v1::Interpreter::collect_metadata(script))?;
        serde_json::to_string(&meta.value).map_err(|err| err.to_string())
    } else {
        let script = v0::Parser::default()
            .parse(&input)
            .map_err(|err| err.to_string())?;
        let meta = meta_of(v0::Interpreter::collect_metadata(script))?;
        serde_json::to_string(&meta.value).map_err(|err| err.to_string())
    }
}
