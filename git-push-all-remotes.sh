#!/bin/bash
AR=($(git remote))
function join_by { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; }
confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}



# echo "$my_array_length"


confirm "Would you really like to do a push? On these remotes $(join_by ', ' ${AR[@]}) ? (y/n)" 
if [[ $? -eq 0 ]]; then
  echo 'Pushing to your remotes'  
  for i in "${!AR[@]}"; do   
    eval git remote get-url ${AR[$i]}  
  done
fi


# for remoteLine in "${!AR[@]}"
# do
# printf "%s\t%s\n" "$i" "${foo[$i]}"
# echo "$remoteLine"



# done
