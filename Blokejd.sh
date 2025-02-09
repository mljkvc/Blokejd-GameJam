#!/bin/sh
echo -ne '\033c\033]0;Blokejd\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Blokejd.x86_64" "$@"
