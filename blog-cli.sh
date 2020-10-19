#!/bin/bash

DIR=$( cd $( dirname "${0}" ) && pwd )
cd "${DIR}"
## ======================================

_create_post() {
    mkdir -p "_posts/$(date +%Y-%m)"
    local _title=$(python -c "import re; import cyrtranslit; import sys; print(re.sub('[ ]', '-', cyrtranslit.to_latin(' '.join(sys.argv[1:]), 'ru')).lower());" "$*")
    local _file="_posts/$(date +%Y-%m)/$(date +%Y-%m-%d)-${_title}.md"
    echo $_file
    touch $_file
}

_cmd="$1"
shift

case "$_cmd" in
    post)
        _create_post "$@"
    ;;
    2|3)
        echo "case 2 or 3"
    ;;
    *)
        echo "default"
    ;;
esac


#cat _posts/2020-09/folder/2020-09-21-welcome-to-jekyll.md | sed -n '/^tags:/p' | sed 's/tags://; s/\W/ /g'
