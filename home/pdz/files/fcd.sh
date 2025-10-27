fcd(){
    selected=$(find ~/Documents ~/work -mindepth 1 -maxdepth 1 -type d | fzf)
    if [[ -n $selected ]]; then
        cd $selected
    fi
}