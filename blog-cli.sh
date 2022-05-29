#!/bin/bash

DIR=$( cd $( dirname "${0}" ) && pwd )
cd "${DIR}"
## ======================================

_help() {
    cat <<EOF
Usage: ${0} <cmd>

    post <name>  - создать новый пост и сформировать файл
    tags [-c]    - сгенерировать теги. С флагом -с добовляет в git

EOF
}



_create_post() {
    if [ -z "$*" ]; then
        _help
        return 1
    fi
    local _title="$*"
    mkdir -p "_posts/$(date +%Y-%m)"
    local _name=$(python3 -c "import re; import cyrtranslit; import sys; print(re.sub('[ ]', '-', cyrtranslit.to_latin(' '.join(sys.argv[1:]), 'ru')).lower());" "$*")
    _name="${_name/\'/}"
    local _file_default="_posts/default.md"
    local _file="_posts/$(date +%Y-%m)/$(date +%Y-%m-%d)-${_name}.md"
    echo $_file
    # cp $_file_default $_file
    # touch $_file
    cat > $_file <<EOF
---
layout: post
title:  "${_title}"
tags: [doc]
---

Default content

EOF
}

_generate_tags() {
    local _git_commit=
    while getopts "ch" opt; do
        case $opt in
            c) _git_commit="1";;
            h) echo " -c  git add file"; exit ;;
        esac
    done
    
    # grep -h -R -o -P
    grep -h -r -o -E 'tags: .*' _posts/ | sed 's/tags: //g; s/\[\|\]//g; s/[, ]/\n/g; s/\n\n/\n/g; s/\r//g; s/ //g' | sort | uniq | while read t; do
        if [[ ( "${t}" != "" ) ]]; then
          if [[ ( ! -f "tag/${t}.md" ) && ( "${t}" != "" ) ]]; then 
              sed "s/{tag}/${t}/g" tag/_template.md > "tag/${t}.md"
              if [[ "$_git_commit" == "1" ]]; then
                  echo "git add tag/${t}.md"
                  git add "tag/${t}.md"
              fi
              echo $t
          fi
          if [[ "$_git_commit" == "1" ]]; then
            git add "tag/${t}.md"
          fi
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
        _help
    ;;
esac


#cat _posts/2020-09/folder/2020-09-21-welcome-to-jekyll.md | sed -n '/^tags:/p' | sed 's/tags://; s/\W/ /g'
