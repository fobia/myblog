#!/bin/bash

DIR=$( cd $( dirname "${0}" ) && pwd )
cd "${DIR}"
## ======================================

_create_post() {
    mkdir -p "_posts/$(date +%Y-%m)"
    local _title=$(python3 -c "import re; import cyrtranslit; import sys; print(re.sub('[ ]', '-', cyrtranslit.to_latin(' '.join(sys.argv[1:]), 'ru')).lower());" "$*")
    local _file="_posts/$(date +%Y-%m)/$(date +%Y-%m-%d)-${_title}.md"
    echo $_file
    touch $_file
}

_generate_tags() {
    local _git_commit=
    while getopts "ch" opt; do
        case $opt in
            c) _git_commit="1";;
            h) echo " -c  git add file"; exit ;;
        esac
    done


    grep -h -R -o -P 'tags: .*' _posts/ | sed 's/tags: //g; s/\[\|\]//g; s/[, ]/\n/g; s/\n\n/\n/g; s/\r//g; s/ //g' | sort | uniq | while read t; do
        if [[ ! -f "tag/${t}.md" ]]; then 
            sed "s/{tag}/${t}/g" tag/_template.md > "tag/${t}.md"
            if [[ "$_git_commit" == "1" ]]; then
                git add "tag/${t}.md"
            fi
            echo $t
        fi
    done
}

_cmd="$1"
shift

case "$_cmd" in
    post)
        _create_post "$@"
    ;;
    tags)
        _generate_tags "$@"
    ;;
    *)
        echo "default"
    ;;
esac


#cat _posts/2020-09/folder/2020-09-21-welcome-to-jekyll.md | sed -n '/^tags:/p' | sed 's/tags://; s/\W/ /g'
