########### Path update
## Emacs + doom
export PATH=.emacs.d/bin:$PATH
export PATH=~/.config/emacs/bin:$PATH
## Go
export PATH=$PATH:/usr/local/go/bin


########### Aliases 
## Git alias 
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'" 
## Z, a better cd 
eval "$(zoxide init bash)" 
###### Staship 
eval "$(starship init bash)" 
## Exa 
if [ "$(command -v exa)" ]; then 
    unalias 'ls' 
    unalias 'll' 
    unalias 'la' 
    alias ls='exa -G --color auto -s type --icons' 
    alias la='exa -G --color auto -s type -a' 
    alias ll='exa -G --color auto -s type -l --icons' 
fi 
## Batcat 
if [ "$(command -v batcat)" ]; then 
    alias cat='batcat -pp --theme="Visual Studio Dark+"' 
fi

alias codium="flatpak run com.vscodium.codium --no-sandbox "
alias fd=fdfind

source /home/guillaume/alacritty/extra/completions/alacritty.bash
