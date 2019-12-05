#!/usr/bin/env bash

script_dir=./scripts

# 初期値読み込み
source ./initial.sh

# スクリプトを実行
run () { source $@; }

## タイトル
run $script_dir/start.sh

## 設定
run $script_dir/load-settings.sh

# ネット接続確認
run $script_dir/check-network.sh

# Rootチェック
run $script_dir/check-root.sh

# ディストリビューションチェック
run $script_dir/check-os.sh