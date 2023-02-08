# shellcheck disable=SC2148
# ~/.bash_functions

function _git_newpush() {
    __gitcomp_direct "$(git remote show)"
}

batdiff() {
    git diff --name-only --diff-filter=d | xargs bat --diff
}

notify() {
    eval "$@"
    curl "localhost:8700/cmd?err=$?"
    echo 
}

repeat() {
    seq "$1" | xargs -Iz "${@:2}"
}

retry() {
    local n=0
    local max_attempts=
    local cmd_exit_code=0
    local until_failure=

    if [[ $# -lt 1 ]]; then
        echo "Usage: \`retry [-n max_retry_count] [-f] <Command>\`"
        return 1
    fi

    while true; do
        case $1 in
            -n) shift
                max_attempts=$1
                shift ;;
            -f) shift
                until_failure=true ;;
            -*) echo "retry: Unrecognized option $1" >&2
                exit 2;;
            *) break ;;
        esac
    done

    local cmd="${*: 1}"

    while true; do
        $cmd
        cmd_exit_code=$?

        [[ -z $until_failure && "$cmd_exit_code" = "0" ]] && break
        [[ -n $until_failure && "$cmd_exit_code" != "0" ]] && break

        ((n++))

        [[ -n $max_attempts && $n -ge $max_attempts ]] && break

        sleep 1;
    done

    return $cmd_exit_code
}

function awsprofile() {
    if aws configure list-profiles | grep -qw "$1"; then
        export AWS_PROFILE="$1"
    else
        echo "\"$1\" is not a configured AWS profile."
        return 1
    fi
}
