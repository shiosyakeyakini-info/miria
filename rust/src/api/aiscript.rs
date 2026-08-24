//! AiScript 実行環境の Rust 側入口。
//!
//! AiScript の処理系そのものは aiscript-rs (MIT-0) に任せ、ここでは
//! Dart から呼べる形に包むだけにする。

use std::sync::{Arc, Mutex};

use aiscript::v1;
use futures::FutureExt;

/// 組み込んでいる AiScript のバージョン。
pub fn aiscript_version() -> String {
    String::from(v1::AISCRIPT_VERSION)
}

/// スクリプトを実行し、`<:` で出力された行を返す。
///
/// Rust 連携が通っているかを確かめるための最小実装。Play 本体の環境
/// (Mk:api / Ui:C:* など) はまだ生えていない。
pub async fn eval(input: String) -> Result<Vec<String>, String> {
    let output = Arc::new(Mutex::new(Vec::<String>::new()));
    let interpreter = v1::Interpreter::new(
        [],
        None::<fn(_) -> _>,
        Some({
            let output = output.clone();
            move |value: v1::values::Value| {
                if let Ok(mut output) = output.lock() {
                    // 本家 Misskey の scratchpad が `<:` の出力に使う
                    // utils.reprValue 相当
                    output.push(value.repr_value().to_string());
                }
                async move {}.boxed()
            }
        }),
        None::<fn(_) -> _>,
        None,
    );
    let script = v1::Parser::default()
        .parse(&input)
        .map_err(|err| err.to_string())?;
    interpreter.exec(script).await.map_err(|err| err.to_string())?;
    let output = output.lock().map_err(|err| err.to_string())?;
    Ok(output.clone())
}
