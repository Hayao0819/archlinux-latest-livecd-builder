#!/usr/bin/env bash


## 変数定義
year=`date "+%Y"`
month=`date "+%m"`
day=`date "+%d"`


## 設定
#このディレクトリ内に設定ファイル等を作成するため空のディレクトリを指定することをおすすめします。
working_directory="/home/arch-build" 
#フルパスで表記してください。それぞれ${yaer}、${month}、${day}で年、月、日に置き換えることができます。
image_file_path="/home/archlinux-${year}.${month}.${day}-x86_64.iso" 
#以下の設定は通常は変更しません。
archiso_package_name="archiso" #pacaptのパッケージ名です。(AURのパッケージ名にする場合はAURHelperを有効化してください。)
aur_helper="yay" #AURHelperの使用を強制する場合にのみpacmanから変更してください。もし存在しないAURHelperが入力された場合はpacmanが使用されます。また、AURHelperはpacmanと同じ構文のもののみ利用可能です。
bluelog=0 #0=有効 1=無効 それ以外=有効


## 関数定義
function red_log () {
    echo -e "\033[0;31m$@\033[0;39m" >&2
    return 0
}

function blue_log () {
    if [[ ! $bluelog = 1 ]]; then
    echo -e "\033[0;34m$@\033[0;39m"
    fi
    return 0
}

function yellow_log () {
    echo -e "\033[0;33m$@\033[0;39m" >&2
    return 0
}

function package_check () {
    if [[ -z $1 ]]; then
        red_log "Please specify a package."
        exit 1
    fi
    if [[ -n $( pacman -Q | awk '{print $1}' | grep -x "$1" ) ]]; then
        return 0
    else
        return 1
    fi
}

## Rootチェック
if [[ ! $UID = 0 ]]; then
    red_log "You need root permission." >&2
    exit 1
fi


## ディストリビューションチェック
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ ! $ID = "arch" ]]; then
        red_log "The script is able to run in ArchLinux only."
        exit 1
    fi
else
    red_log "There is not /etc/os-release."
    exit 1
fi


## AUR Helperチェック
if [[ $(package_check $aur_helper ; printf $? ) = 1 && ! $aur_helper = "pacman" ]]; then
    pacman=pacman
else
    blue_log "Found AUR_Helper $aur_helper."
    blue_log "Use $aur_helper"
    pacman=$aur_helper
fi

## ArchISOインストール
if [[ $(package_check $archiso_package_name ; printf $?) = 1 ]]; then
    yellow_log "ArchISO is not installed."
    yellow_log "Install ArchISO."
    $pacman -Syy --noconfirm
    $pacman -S --noconfirm archiso
fi


## 作業ディレクトリ作成
if [[ ! -d $working_directory ]]; then
    mkdir -p $working_directory
    chmod 755 $working_directory
else
    printf "Working directory already exists. Do you want to initialize it? :"
    read yn
    alias del='rm -rf $working_directory'
    case $yn in
        y ) del ;;
        Y ) del ;;
        Yes ) del ;;
        yes ) del ;;
        * ) exit 1
    esac
    mkdir -p $working_directory
    chmod 755 $working_directory
fi

if [[ ! -d $working_directory/out/ ]]; then
    mkdir -p $working_directory/out/
    chmod 755 $working_directory/out/
fi

## ArchISOプロファイルコピー
if [[ -d /usr/share/archiso/configs/baseline/ ]]; then
    cp -r /usr/share/archiso/configs/baseline/* $working_directory
else
    red_log "There is not ArchISO profiles."
    red_log "Please Install ArchISO"
    exit 1
fi

## ISO作成
blue_log "Start building ArchLinux LiveCD."
cd $working_directory
./build.sh -v
mv $working_directory/out/* $image_file_path
blue_log "Created ArchLinux Live CD in $image_file_path"
rm -r $working_directory
