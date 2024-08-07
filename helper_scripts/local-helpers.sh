# shellcheck disable=SC2148
# NOTE: this file to be sourced

ARGS=$(echo "$@" | tr '[:upper:]' '[:lower:]')

# shellcheck disable=SC2034
WSL=$(uname -a | grep -iq microsoft && echo 'true' || echo 'false')
MAC=$(uname -a | grep -q Darwin && echo 'true' || echo 'false')

if $MAC; then
    function grep() {
         ggrep "$@"
    }
    function ls() {
         gls "$@"
    }
    function stat() {
         gstat "$@"
    }
fi

# Returns true if the specified arg is present in $ARGS
function has_arg() {
    echo "$ARGS" | grep -Pq "(^| )$1( |$)"
}

# Returns true if the variable specified in $1 has the text specified in $2
function var_has() {
    echo "${!1}" | grep -q "$2"
}

# Returns true if the file specified in $1 has the text specified in $2
function file_has_line() {
    grep -q "$2" "$1"
}

if [ -z ${PACKAGE_MANAGER+x} ]; then
    if [[ "" != "$(which apt-get)" ]]; then
        PACKAGE_MANAGER="apt-get -o Acquire::ForceIPv4=true"
    elif [[ "" != "$(which yum)" ]]; then
        PACKAGE_MANAGER=yum
    elif [[ "" != "$(which brew)" ]]; then
        PACKAGE_MANAGER=brew
    else
        echo "None of [apt-get|yum|brew] are present. No suitable package manager found; exiting."
        exit 1
    fi
fi

function pkg-mgr() {
    # shellcheck disable=SC2068
    $PACKAGE_MANAGER $@
}

function sudo-pkg-mgr() {
    # shellcheck disable=SC2068
    if $MAC; then
        $PACKAGE_MANAGER $@
    else
        sudo $PACKAGE_MANAGER $@
    fi
}
