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
    if aws configure list-profiles 2>/dev/null | grep -qw "$1"; then
        export AWS_PROFILE="$1"
        unset AWS_ACCESS_KEY_ID
        unset AWS_SECRET_ACCESS_KEY
        unset AWS_SESSION_TOKEN
    else
        echo "\"$1\" is not a configured AWS profile."
        return 1
    fi
}

function aws_assume_role() {
    # See https://stackoverflow.com/questions/63241009/aws-sts-assume-role-in-one-command
    # shellcheck disable=SC2046,SC2183,SC2068
    export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
        $(aws sts assume-role $@ \
        --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
        --output text))
    unset AWS_PROFILE
}

function set_aws_creds() {
    credential_json="$*"

    AWS_ACCESS_KEY_ID="$(echo "$credential_json" | jq -r '.Credentials.AccessKeyId')"
    AWS_SECRET_ACCESS_KEY="$(echo "$credential_json" | jq -r '.Credentials.SecretAccessKey')"
    AWS_SESSION_TOKEN="$(echo "$credential_json" | jq -r '.Credentials.SessionToken')"

    export AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY
    export AWS_SESSION_TOKEN
    unset AWS_PROFILE
}

function pick_aws_config() {
    grep '\[profile ' ~/.aws/config | sed -nr 's/\[profile ([a-z0-9_-]+)\]/\1/p' | fzf --height 20%
}

function git-exclude-local() {
    grep "$1" .git/info/exclude || echo "$1" >> .git/info/exclude
}
