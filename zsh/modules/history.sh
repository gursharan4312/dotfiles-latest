HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000

if [[ ! -f $HISTFILE ]]; then
    touch $HISTFILE
    chmod 600 $HISTFILE
fi

setopt appendhistory
setopt extendedhistory
setopt sharehistory
setopt incappendhistory
setopt histignoredups
setopt histignorespace
