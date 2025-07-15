#!/bin/sh
echo -ne '\033c\033]0;untitled-defense-push-game\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/untitled-defense-push-game.x86_64" "$@"
