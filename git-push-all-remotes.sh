#!/bin/bash
AR=($(git remote))
CLEAR='\033[0m'
RED='\033[0;31m'
#greenColor=`tput setaf 2`
greenColor=$(tput setaf 2)
function join_by { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; }
function usage() {
  if [ -n "$1" ]; then
    echo -e "${RED}👉 $1${CLEAR}\n";
  fi
  echo "Usage: $0 [-y]"
  echo "  -y, --yes, y, yes        Confirm the push to remotes"
  echo "  -h, --help               Show this help"
  echo ""
  echo "Example: $0 -y"
  exit 1
}
confirm() {
    read -r -p "${1:-Are you sure? [y/N]} " response
    response=${response,,} # tolower
    if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
        return 1
    else
        return 0
    fi
}
function pushToRemotes() {
    echo "${greenColor}Pushing to your remotes"
    for i in "${!AR[@]}"; do
        eval tput setaf 0
        # eval git push ${AR[$i]} $(git rev-parse --abbrev-ref HEAD)
        eval git push "${AR[$i]}" $(git rev-parse --abbrev-ref HEAD)
    done
}

while [[ "$#" > 0 ]]; do case $1 in
  -y|--yes|y|yes) CONFIRMATION=1; shift;shift;;
  -h|--help) HELP_TRIGGER=1; shift;shift;;
  *) usage "Unknown parameter passed: $1"; shift; shift;;
esac; done

if [[ $HELP_TRIGGER -eq 1 ]]; then
    usage
    exit
fi


echo "$(tput setaf 6)$(git rev-parse --abbrev-ref HEAD) -> $(join_by ', ' ${AR[@]})$(tput sgr0)"

if [[ $CONFIRMATION -eq 1 ]]; then
    echo "$(tput setaf 0)(-y) direct"
    pushToRemotes
else
    confirm "Would you really like to do a push? On these remotes $(join_by ', ' ${AR[@]}) ? (y/n)"
    if [[ $? -eq 1 ]]; then
        echo $?
        pushToRemotes
    fi

fi
