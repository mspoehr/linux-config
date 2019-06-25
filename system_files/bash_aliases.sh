# ~/.bash_aliases

alias ls="ls $COLOR_AUTO -F"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep="grep $COLOR_AUTO"

alias dos2unixr='find . -type f -exec dos2unix {} \;'
alias unix2dosr='find . -type f -exec unix2dos {} \;'
alias tm=tmux
alias preview="fzf --preview 'bat --color \"always\" {}'"
# add support for ctrl+o to open selected file in vim
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(vim {})+abort'"
alias www='python3 -m http.server --bind localhost --cgi 8000'
alias sshkeygen='ssh-keygen -t rsa'
alias sshkeyinstall='ssh-copy-id -i ~/.ssh/id_rsa.pub'
alias g='git'
alias s="echo $?"
alias c='clear'
alias krep='grep -rniIs'
alias findf='find . -type f -iname'
alias findd='find . -type d -iname'
alias findl='find . -type l -iname'
alias dd='dd status=progress'
alias recent='ls -lct $(find . -type f -iname "*") | less'
alias mdv='grip -b'
alias mde='grip --export'
alias usage=ncdu
alias whatsmyip='printf "$(curl -s ipecho.net/plain)\n"'
alias wan-ip='whatsmyip'
alias lan-ip="hostname -I | awk '{print $1}'"

function ruby_setup() {
    source ~/.rvm/scripts/rvm
    rvm use 2.6.0
}

# try-again: repeat the last command, but with an edit
function try-again() {
    if [[ $# != 2 ]]; then
        echo "Usage: try-again WORD REPLACEMENT"
        return 1
    fi
    COMMAND=$(echo $(history -p !!) | sed s/$1/$2/g)
    if [[ $? == 0 ]]; then
        if [[ $COMMAND == *"sudo"* ]]; then
            echo "NOTICE: not running because contains \"sudo\""
            echo "Your modified command is: \"$COMMAND\""
        else
            echo "Trying again as: \"$COMMAND\""
            $COMMAND
        fi
    fi
}
alias ta='try-again'

#create function to "cd" and "ls" in one command, "cs"
function cs() {
    new_directory="$*";
    if [ $# -eq 0 ]; then
        new_directory=${HOME};
    fi;
    builtin cd "${new_directory}" && ls
}

#create function to "cd" and "ls -al" in one command, "csal"
function csal() {
    new_directory="$*";
    if [ $# -eq 0 ]; then
        new_directory=${HOME};
    fi;
    builtin cd "${new_directory}" && ls -al
}

function cgs() {
    clear && git status
}

function cgt {
    clear && git tree-simple
}

function cls() {
    clear && ls
}

function mkcd() {
    mkdir $1 && cd $1
}

function showme() {
    set -x && $@ && set +x
}

function serial() {
    BAUD=115200
    if [[ $# > 0 ]]; then
        BAUD=$1
    fi
    if [[ ! -d /run/screen ]]; then
        sudo mkdir -p /run/screen
        sudo chmod 777 /run/screen
    fi

    TTYS="$(ls /dev/ttyUSB? 2> /dev/null) $(ls /dev/ttyS? 2> /dev/null)"
    for TTY in $TTYS; do
        if [[ 666 != $(stat -c %a $TTY) ]]; then
            sudo chmod 666 $TTY
        fi
        echo "Trying $TTY"
        stty -F $TTY &> /dev/null
        if [[ $? = 0 ]]; then
            echo "Connecting to $TTY"
            screen $TTY $BAUD
            break
        fi
    done
}

function dive() {
    docker pull wagoodman/dive
    docker run --rm -it \
        -v /var/run/docker.sock:/var/run/docker.sock \
        wagoodman/dive:latest $@
}

function git-author-rewrite() {
    if [[ $# < 2 ]]; then
        echo Usage: git-author-rewrite OLD_EMAIL NEW_EMAIL
        exit
    fi

    git filter-branch --env-filter '

    OLD_EMAIL='"$1"'
    CORRECT_NAME="Kevin Kredit"
    CORRECT_EMAIL='"$2"'

    if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]; then
        export GIT_COMMITTER_NAME="$CORRECT_NAME"
        export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
    fi

    if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]; then
        export GIT_AUTHOR_NAME="$CORRECT_NAME"
        export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
    fi

    ' --tag-name-filter cat -- --branches --tags
}

extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# For long running commands.  Use like so:
#   sleep 10; alert
function alert() {

    if [[ 0 == $? ]]; then
        ALERT_TITLE="Command Success"
        TERM_MSG_COLOR=$green
    else
        ALERT_TITLE="Command Error"
        TERM_MSG_COLOR=$red
    fi

    COMMAND="$(history | tail -n1 | sed -e 's/^\s    *[0-9]\+\s*//;s/[;&|]\s*alert$//')"

    notify-send --urgency=low -i "$ALERT_TITLE" "$COMMAND"

    echo -e "$TERM_MSG_COLOR"
    echo "==============================================================================="
    echo "$ALERT_TITLE:"
    echo "$COMMAND"
    echo "==============================================================================="
    echo -e $no_color
}