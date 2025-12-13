# --- Powerlevel10k Instant Prompt (最上部に配置必須) ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Zsh Basic Options (快適性のための基本設定) ---
# ヒストリー設定
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # 履歴を他のタブと共有
setopt HIST_IGNORE_DUPS       # 直前と同じコマンドは記録しない
setopt HIST_IGNORE_ALL_DUPS   # 重複する古い履歴を削除
setopt AUTO_CD                # cdなしでディレクトリ移動

# 補完機能の有効化
autoload -Uz compinit && compinit

# 色の有効化
autoload -Uz colors && colors
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# --- Environment Variables (環境変数) ---
# PATH: ユーザーローカルbinを優先
export PATH="$HOME/.local/bin:$PATH"
# Snap path fix
export PATH="/snap/bin:$PATH"

# Go Lang
export GOROOT=/usr/local/go
export GOPATH=$HOME/.local/share/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# TeX
export TEXMFHOME="$HOME/.local/share/texmf"

# ROS 2 Localhost Only (bashrcから移植)
export ROS_LOCALHOST_ONLY=1

# --- Pyenv Settings (bashrcから移植・Zsh最適化) ---
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# --- Modern LS (lsd) ---
alias ls='lsd'
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'

# リスト表示のショートカット
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# ツール系
alias t='tmux'

# --- Functions & Bindings ---

# ghq + fzf (リポジトリ移動)
function ghq-fzf() {
  local src=$(ghq list | fzf --preview "ls -laTp $(ghq root)/{} | tail -n+2 | head -n 20")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq-fzf
bindkey '^g' ghq-fzf

# --- Tool Initializations (末尾付近に配置) ---

# Conda initialize
__conda_setup="$('/home/yoichi/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/yoichi/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/yoichi/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/yoichi/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# mkjigコマンド
# 思考治具生成コマンド
# 使用法: mkjig [ディレクトリ名]
function mkjig() {
    # 1. 引数チェック: ディレクトリ名が指定されていない場合は警告して終了
    if [[ -z "$1" ]]; then
        echo "エラー: ディレクトリ名を指定してください．"
        echo "使用法: mkjig [ディレクトリ名]"
        return 1
    fi

    local target_dir="$1"

    # 2. ディレクトリ作成
    if mkdir -p "$target_dir"; then
        echo "ディレクトリを作成しました: $target_dir"
    else
        echo "エラー: ディレクトリの作成に失敗しました．"
        return 1
    fi

    # 3. 治具A（アブダクション）の生成
    cat << 'EOF' > "$target_dir/Abduction_Jig.md"
# 【治具A：推論の骨組み構築（アブダクション強制）】
> **目的：** 目の前の事象から，もっともらしい仮説を導き出す．

1. 【観測事実（Fact）】
   - (主観や解釈を入れず、数値や状態のみを記述せよ)
   -

2. 【驚き・違和感（Gap）】
   - (本来あるべき状態と、現在の状態の差分は何か？)
   - 期待値：
   - 現実：

3. 【仮説生成（Abduction）】
   - (そのGapを説明できる「可能性」を3つ挙げよ。バカげたものでも良い)
   - 仮説α（ハードウェア要因）：
   - 仮説β（ソフトウェア/ロジック要因）：
   - 仮説γ（環境/外部要因）：

4. 【選択と根拠】
   - (最も確からしい仮説を選び、なぜそう思うか記述せよ)
   - 選択：
   - 理由：
EOF

    # 4. 治具B（抽象化）の生成
    cat << 'EOF' > "$target_dir/Abstraction_Jig.md"
# 【治具B：本質の抽出（抽象化強制）】
> **目的：** 具体的な問題から構造を抜き出し，他の問題に応用可能な形にする．

1. 【対象の要約（Concrete）】
   - (5歳児にもわかるように1行で説明せよ)
   -

2. 【変数の特定（Variables）】
   - (この問題を構成している要素は何か？N=名詞で挙げよ)
   - V1:
   - V2:

3. 【関係性の定義（Structure）】
   - (変数同士はどういう関係か？動詞で記述せよ。Aが増えればBが減る、等)
   - 関係式：f(V1) -> V2

4. 【アナロジー（Metaphor）】
   - (これと全く同じ構造を持つ「別の分野」の事例は何か？)
   - 例：これは「恋愛」で言うところの「片思い」と同じ構造だ。
   - アナロジー：
EOF

    # 5. 治具C（検証）の生成
    cat << 'EOF' > "$target_dir/Verification_Jig.md"
# 【治具C：論理の強固化（反証強制）】
> **目的：** 導き出した結論を破壊テストし，論理的飛躍を防ぐ．

1. 【主張（Argument）】
   - (検証したい結論・アクションプラン)
   -

2. 【悪魔の代弁者（Devil's Advocate）】
   - (この主張が「100%間違っている」と仮定し、その場合の最大の根拠を挙げよ)
   - 反論：

3. 【前提の再確認（Premise Check）】
   - (この主張が成立するために「無意識に依存している前提」は何か？)
   - 隠れた前提：(例：電源が入っていること、相手が日本語を話せること)

4. 【修正（Refinement）】
   - (反論と前提を考慮し、主張をより厳密な言葉に書き換えよ)
   - 修正後の主張：
EOF

    echo "思考治具の配備完了．思考を開始せよ："
    cd $target_dir
}

# Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/.local/powerlevel10k/powerlevel10k.zsh-theme

# --- Zsh Plugins ---
source ~/.local/share/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.local/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ROS 2 Setting (必ず末尾)
source /opt/ros/humble/setup.zsh
source ~/src/GIT/ros2_ws/install/setup.zsh
source ~/src/GIT/ros2_ws/install/local_setup.zsh
