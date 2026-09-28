export JAIL_PATH="$HOME/_jails/blackarch"

function blackarch() {
    if [[ ! -d "$JAIL_PATH" ]]; then
        echo "Error: Jail path '$JAIL_PATH' does not exist." >&2
        return 1
    fi

    # 引数判定: 'root' や '-r' が指定されたら root、それ以外は testuser
    local target_user="testuser"
    if [[ "$1" == "root" || "$1" == "-r" ]]; then
        target_user="root"
    elif [[ -n "$1" && "$1" != "testuser" && "$1" != "-u" ]]; then
        # 任意のユーザー名が渡された場合（例: blackarch otheruser）
        target_user="$1"
    fi

    echo "[*] Entering BlackArch jail as: $target_user"

    # マウントポイントの確保
    sudo mkdir -p "$JAIL_PATH"/{proc,sys,dev,dev/pts,etc}

    # マウント処理（devtmpfsでデバイスノードを安全に自動生成）
    mountpoint -q "$JAIL_PATH/proc" || sudo mount -t proc proc "$JAIL_PATH/proc"
    mountpoint -q "$JAIL_PATH/sys"  || { sudo mount --rbind /sys "$JAIL_PATH/sys" && sudo mount --make-rslave "$JAIL_PATH/sys"; }
    mountpoint -q "$JAIL_PATH/dev"  || sudo mount -t devtmpfs devtmpfs "$JAIL_PATH/dev"
    mountpoint -q "$JAIL_PATH/dev/pts" || sudo mount --bind /dev/pts "$JAIL_PATH/dev/pts"
    # DNS設定の同期
    sudo cp -L /etc/resolv.conf "$JAIL_PATH/etc/resolv.conf"

    # 終了時（exitや中断）の自動クリーンアップ
    cleanup() {
        echo -e "\n[+] Unmounting blackarch jail..."
        sudo umount -l "$JAIL_PATH/dev/pts" 2>/dev/null
        sudo umount -l "$JAIL_PATH/dev" 2>/dev/null
        sudo umount -l "$JAIL_PATH/sys" 2>/dev/null
        sudo umount -l "$JAIL_PATH/proc" 2>/dev/null
    }
    trap cleanup EXIT INT TERM

    # --userspec オプションで起動ユーザーを切り替え
    # root 以外で入った場合は ../../ による脱獄がカーネルレベルで完全にブロックされます
    # functions.zsh の該当ブロック
    if [[ "$target_user" == "root" ]]; then
        sudo unshare -m -p -u -i -f chroot "$JAIL_PATH" /usr/bin/bash --login
    else
        sudo unshare -m -p -u -i -f chroot "$JAIL_PATH" /usr/bin/su - "$target_user"
    fi

    cleanup
    trap - EXIT INT TERM
}
