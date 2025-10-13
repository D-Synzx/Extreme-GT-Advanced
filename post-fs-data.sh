MODDIR=${0%/*}

my_mount(){
    source="${2:-$MODDIR/$1}"
    chmod --reference "$1" "$source"
    chown --reference "$1" "$source"
    chcon --reference "$1" "$source"
    mount --bind "$source" "$1"
}

my_mount_recursive() {
    for file in "$MODDIR/$1"/*; do
        sub_item=$(basename "$file")
        target_path="$1/$sub_item"
        if [ -f "$file" ]; then
            my_mount "$target_path" "$file"
        elif [ -d "$file" ]; then
            mkdir -p "$target_path"
            my_mount_recursive "$1/$sub_item"
        fi
    done
}

my_mount_recursive "/my_product"
my_mount_recursive "/odm"
my_mount_recursive "/system_ext"