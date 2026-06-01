# ====================================================================
# Fish 最強設定ファイル（完全無欠・エラー修正版）
# ====================================================================

### --- 0. キーバインド設定 (Key Bindings) ---
# 💡 キーバインド関連は、起動時に確実に読み込ませるためファイルの先頭に配置します。

# !$ を打った瞬間に直前の引数（トークン）に変化させる魔法
function bind_dollar
    switch (commandline -t)
        # もし直前が「!」だったら、それを消して直前の引数を呼び出す
        case "*!"
            commandline -f backward-delete-char history-token-search-backward
        # 普通の「$」の時は、ただの「$」として入力する
        case "*"
            commandline -i '$'
    end
end

# Fishの起動時に自動でキーバインドを登録する関数
function fish_user_key_bindings
    # !$ 用のバインド（! は普通に入力し、$ が押された時に上の関数を呼ぶ）
    bind '$' bind_dollar
end


### --- 1. システム・基本挙動 ---
# 履歴の保存件数を無限に近く設定
set -g fish_history_limit 100000

# 挨拶メッセージを非表示にして画面をミニマルにする
set -g fish_greeting ""


### --- 2. 環境変数 & パス設定 (Environment) ---
# Fish独自の高速なパス追加機能を使用
fish_add_path $HOME/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/Library/Python/3.9/bin

# LLVM（コンパイラ演習用）のパス
if test -d (brew --prefix)/opt/llvm/bin
    fish_add_path (brew --prefix)/opt/llvm/bin
end

# macOS SDK用環境変数
if test -f /usr/bin/xcrun
    set -gx SDKROOT (xcrun --sdk macosx --show-sdk-path)
end


### --- 3. 外観設定 (Colors & Layout) ---
# lsのカラー設定
set -gx LSCOLORS "xxxxxxxxfxbxegedabagacad"

# プロンプトの見た目設定 (zshの反転ハイライトまで完全再現)
function fish_prompt
    set_color --reverse
    echo -n "+"
    
    set_color normal
    set_color -o normal
    echo -n "MacBook"
    
    set_color --reverse
    echo -n "+"
    
    set_color normal
    set_color -o normal
    echo -n "e235718:"
    
    set_color cyan
    echo -n (prompt_pwd)
    
    set_color normal
    echo -n "\$ "
end


### --- 4. エイリアス & 関数 (Aliases & Functions) ---
# エディタ・ツール
alias vi='nvim'
alias vim='nvim'
alias top='htop'

# OS標準の ls をカラー表示にする設定（無限ループ防止のため command を付与）
alias ls='command ls -GF'
alias ll='command ls -lhGF'
alias la='command ls -aGF'
alias cat='bat --style=plain'
alias grep='rg'

# ユーティリティ
alias h='history'
alias safari='open -a Firefox'
alias firefox='open -a Firefox'
alias chatgpt="open -a Firefox https://chatgpt.com"
alias gemini="open -a Firefox https://gemini.google.com"

# codeコマンドの関数化 (引数が「,」なら「code .」にする挙動の完全移植)
function code
    if test "$argv[1]" = ","
        command code .
    else
        command code $argv
    end
end


### --- 5. 外部ツール連携 (Modern Tools) ---
# fzfの設定（Ctrl + J/K での上下移動を有効化）
set -gx FZF_DEFAULT_OPTS "--bind 'ctrl-j:down,ctrl-k:up,ctrl-n:down,ctrl-p:up'"

# fzfをFishに連動
if test -f ~/.config/fish/conf.d/fzf.fish
    source ~/.config/fish/conf.d/fzf.fish
end


### --- 6. Wiki直伝：!! の最強展開ハック ---
# !! を直前のコマンドにその場で展開する（スペースやEnterを押した瞬間に化けます）
function last_history_item
    echo $history[1]
end 
abbr -a !! --position anywhere --function last_history_item

function fs
    if test (count $argv) -eq 0
        echo "Usage: fs [size]  (e.g., fs 13, fs 11.5)"
        return 1
    end

    set -l new_size $argv[1]
    set -l toml_path "$HOME/.config/alacritty/alacritty.toml"

    if test -f $toml_path
        sed -i '' "s/size *= *[0-9.]*/size = $new_size/" $toml_path
        echo "Alacritty font size changed to $new_size"
    else
        echo "Error: alacritty.toml not found at $toml_path"
    end
end

