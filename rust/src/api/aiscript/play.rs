// AiScript から Misskey を触るための実行環境。
//
// 先行実装である aria (https://github.com/poppingmoon/aria) から移植した。
// aria は miria の git フォークではないが、どちらも AGPL-3.0 である。
//
// SPDX-FileCopyrightText: poppingmoon and miria contributors
// SPDX-License-Identifier: AGPL-3.0-only

use std::collections::HashMap;

use aiscript::{v0, v1};

pub struct AsPlayLib {
    pub this_id: String,
    pub this_url: String,
}

impl AsPlayLib {
    pub(super) fn register_v0(&self, consts: &mut HashMap<String, v0::values::Value>) {
        consts.insert("THIS_ID".to_string(), v0::values::Value::str(&self.this_id));

        consts.insert(
            "THIS_URL".to_string(),
            v0::values::Value::str(&self.this_url),
        );
    }

    pub(super) fn register_v1(&self, consts: &mut HashMap<String, v1::values::Value>) {
        consts.insert("THIS_ID".to_string(), v1::values::Value::str(&self.this_id));

        consts.insert(
            "THIS_URL".to_string(),
            v1::values::Value::str(&self.this_url),
        );
    }
}
