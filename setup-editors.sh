#!/usr/bin/env sh

set -eu

dotfiles_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
backup_suffix=$(date "+%Y%m%d-%H%M%S")

link_config() {
    source_path=$1
    target_path=$2

    if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
        return
    fi

    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        mv "$target_path" "$target_path.backup-$backup_suffix"
        printf 'Backed up %s\n' "$target_path"
    fi

    ln -s "$source_path" "$target_path"
    printf 'Linked %s\n' "$target_path"
}

mkdir -p "$HOME/.config"
link_config "$dotfiles_dir/.vimrc" "$HOME/.vimrc"
link_config "$dotfiles_dir/.config/nvim" "$HOME/.config/nvim"

if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if command -v vim >/dev/null 2>&1; then
    vim -Nu "$HOME/.vimrc" -n -es -c "PlugInstall --sync" -c "qa"
fi

if command -v nvim >/dev/null 2>&1; then
    nvim --headless "+Lazy! sync" +qa
    nvim --headless \
        "+MasonInstall basedpyright ruff typescript-language-server gopls rust-analyzer" \
        +qa
else
    printf '%s\n' 'Neovim is not installed. Install it, then run this script again.'
fi
