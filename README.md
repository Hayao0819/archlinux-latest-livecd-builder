# archiso-builder
ArchISOの補助を行います。デフォルト設定で最新のLiveCDをビルドすることもできます。  
~~（もともとは最新のCDをビルドするためだったんだが...）~~  
↑のスクリプトはarchlinux-builder-mini.shです。  
永遠のalpha版、安定版なんてなかった。（Release1では「完成」となっていますが、実際には多くのバグがあるのでarchlinux-builder-mini.shを使用することをおすすめします。）  


# 現在無効化されている機能
- i686のビルドは現在無効化されており、強制的にx86_64がビルドされます


# テスト中の機能
このスクリプトは永遠のalphaです。安定していない機能でも構わずmasterにぶちこみます。ここでは、現在動作が不安定なものを挙げています。
- ArchLinuxのビルド機能（時々失敗します。再実行すると成功します。）
- AURの自動ビルド（整合性エラーが発生する場合があります。何度か再実行するとうまくいくことがあります。安定して動作させたい場合は手動でカスタムリポジトリを作成してください。）
- Grub背景の変更（初期の方に実装されたけど実は一回もテストしてない）



# 現在わかっているバグ
複数回実行していると成功する場合があり、原因がわかっていません。
- AURの自動ビルドでインストール直前で整合性エラーが出る場合があります。
- 初回実行時のみ、build.shが見つからない場合があります。2回目以降でこのバグが起きたことはありません。



# 注意事項
- ビルドに失敗する場合はもう一度実行してみてください  
- 設定には干渉する値もあります。十分に注意して設定してください。  
- スクリプトはRootユーザーが書き込み権限のあるディレクトリで実行する必要があります。  
- カスタムリポジトリのディレクトリはAURユーザーの書き込み権限のあるディレクトリを指定する必要があります。
- このスクリプトはArchLinuxでのみテストされています。ManjaroなどのArch系列で実行する場合はディストリビューションチェックをコメントアウトしてください。

# 実行方法
デフォルトでは/home/直下にarchlinux-hogehoge-x86_64.isoで作成されます。

```bash
wget -q https://0e0.pw/bFSJ
chmod +x start_build.bash
./start_build.bash
```

# 追加のファイルについて
settings.bashやbuild_i686.shは必須ではありません。  

## start_build.bash
このファイルはビルドする際のランチャーとなるものです。  
必要なファイルを自動でダウンロード、実行します。  
スクリプト内部では、設定ファイルへのURLを指定できます。  
実行するたびにダウンロードを行うので常に最新の状態で利用できます。　　

## message.bash
必須のファイルです。単体で実行した場合は自動でダウンロードされます。  
このファイルを編集することで言語を追加できます。  

## settings.bash
設定を記述したファイルです。archlinux_builder.bashを更新した際に設定を保存できるファイルです。  
引数として設定ファイルへのパスを指定することができます。  
~~（更新によって設定項目が追加された場合、settings.bashに手動で追加する必要があります。）~~  
`ce77b3c `以降は設定が存在しなかった場合はデフォルト設定が使用されます。

## build_i686.sh
i686でビルドするためのスクリプトです。  
直接実行せず、archlinux-builder.bashを経由して実行してください。  
x86_64をビルドする場合は不要です。  

## aur.bash
AURにあるパッケージをビルドして、*.pkg.tar.xzにします。ビルドするには引数としてAURのリポジトリを指定してください。  
スクリプトと同じ階層にパッケージが作成されます。カスタムリポジトリを利用する際に利用できます。  


## archlinux-builder-mini.sh
ArchLinuxの純粋なLiveCDを生成します。（これが本来作りたかったスクリプト）  
生成時の最新のパッケージをそのままイメージファイルにします。

```bash
./aur.bash hogehoge fugafuga
```


# i686

以前はコマンドを追加で実行する必要がありましたが、自動化され必要なくなりました。  
設定ファイルでi686を指定すると自動でbuild_i686.shがダウンロードされます。


# 設定
設定はsettings.bashで設定することが推奨されています。  
（スクリプト内で設定することも可能です。）
設定はスクリプト内に細かく書かれています。


