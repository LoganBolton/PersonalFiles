echo "\033[36m$(figlet -f larry3d -w 120 Logan \'s Trapbook)\033[0m" | lolcat

# Created by `pipx` on 2024-03-15 00:15:29
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export ANTHROPIC_API_KEY=''
export OPENAI_API_KEY=''

alias vim='nvim'
alias python='python3'
alias dir='ls'
alias pip='pip3'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

unalias commit
commit() {
  git add .
  git commit -m "$*"
  git push
}
