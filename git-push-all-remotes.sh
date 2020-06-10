#!/bin/bash
AR=($(git remote))
greenColor=`tput setaf 2`
function join_by { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; }
confirm() {
    read -r -p "${1:-Are you sure? [y/N]} " response
    response=${response,,} # tolower
    if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
       true
    fi
}

echo "$(tput setaf 6)$(git rev-parse --abbrev-ref HEAD) -> $(join_by ', ' ${AR[@]})$(tput sgr0)"
confirm "Would you really like to do a push? On these remotes $(join_by ', ' ${AR[@]}) ? (y/n)"
if [[ $? -eq 0 ]]; then
    echo "${greenColor}Pushing to your remotes"
    for i in "${!AR[@]}"; do
        eval tput setaf 0
        eval git push ${AR[$i]} $(git rev-parse --abbrev-ref HEAD)
    done
fi
