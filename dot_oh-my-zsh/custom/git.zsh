alias gnd='git diff --name-only'
compdef _git gnd=git-checkout
alias gu='git fetch --prune && git up'
alias gf='git fetch --tags && git blist'
alias gda='git diff --cached'
alias gs='git show'
alias gb='git blist'
alias gt='git tag'
alias grt='git remove-tags'
alias gbm='git branch --merged'
alias gbnm='git branch --no-merged'
alias gcm='git commit -m'
alias gcn='git commit --no-edit'
alias gcf='git commit --fixup'
alias gm='git merge --no-edit'
alias gmn='git merge --no-ff --no-edit'
alias gcob='git checkout -b'
alias gcot='git checkout -t'
alias gsta='git stash save -u'
alias glg='git lg'
alias gll='git ll'
alias gmb='git merge-base `git rev-parse --abbrev-ref HEAD`'

# git commit --fixup + rebase -i --autosquash (from a commit message)
function gcfrb
{
    local PATTERN="$1"
    if [[ -z $PATTERN ]]; then
        echo "Usage: $0 pattern"
        return 1
    fi

    local REBASE_HASH=$(git --no-pager log --pretty="%h %s" | grep -i -A1 "$PATTERN" | tail -n1 | cut -d" " -f1)

    if [[ -z $REBASE_HASH ]]; then
        echo "Pattern \"$PATTERN\" not found in git log."
        return 2
    fi
    
    git commit --fixup :/$PATTERN && GIT_SEQUENCE_EDITOR=true git rebase -i --rebase-merges $REBASE_HASH
}

# git tag and push
function gtp
{
    git tag -m "$1" $1 && git push origin $1
}

# increment the semver version as AECF pattern
function grr
{
    local BRANCH=`git rev-parse --abbrev-ref --symbolic-full-name @{u}`
    local QUESTION='git reset --hard '$BRANCH;
    read -q "REPLY?$QUESTION? (y/n) "
    if [ $REPLY = 'y' ]; then
        echo ""
        git reset --hard $BRANCH
    fi
}
