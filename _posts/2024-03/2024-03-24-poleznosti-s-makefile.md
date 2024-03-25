---
layout: post
title:  "Полезности с Makefile"
category: linux
tags: [doc, linux]
summary: Нокоторые полезные приемы в Makefile
---

1. Определяем корень проекта

```Makefile
ENVFILE=.env
MAKEFILE_PATH=.

ifneq ("$(wildcard .env)","")
	# ENVFILE=.env
	APP_DIR=$(shell echo $$(cd . && pwd))
else
	# ENVFILE=../.env
	APP_DIR=$(shell echo $$(cd .. && pwd))
	MAKEFILE_PATH=$(shell basename $$(cd . && pwd))
endif
```
<BR>

2. Добовляем новые переменные в `.env` файл из исходного

```Makefile
.app.update_env:
	cd $(APP_DIR) && $(DC) docker-compose exec -u root app make -f $(MAKEFILE_PATH)/Makefile .app.dc.update_env 

.app.dc.update_env:
	@sed '/^#/d; /^$$/d' .env.example | while read r; do grep "^$${r%%=*}=" .env >/dev/null || (echo $$r >> .env && echo "Add env:  $$r"); done


.app.dc.clear:
	find storage/framework/ -type f \! -name *.gitignore
	find storage/debugbar/ -type f \! -name *.gitignore
	find storage/logs/ -type f \! -name *.gitignore
	find bootstrap/cache/ -type f \! -name *.gitignore
``` 


<BR>

3. Атогенератор help сообщение. Команда должна заканчивать коментарием, чтоб определялась как текс команды

```Makefile

help:
	@echo "Usage: \n"
	@sed -e '/^[a-zA-Z].\+:.\+#/!d' -e 's/^\(.\+\?\):.\+\?## /\1:/' Makefile | awk -F: '{ printf "  %-20s %s\n", $$1, $$2 }'
```

<BR>

4. Проверка синтаксиса только модифицированых файлов

```Makefile
define get_diff_tree
	@git diff --cached --name-only
    @#git cherry origin/master | cut -d " " -f 2 \
            | while read c; do git diff-tree --no-commit-id --name-only -r "$$c"; done \
            | sort | uniq \
            | while read f; do test -f "$$f" && echo "$$f"; done;
endef

define check_code_style
	@echo $$(pwd); \
    DRY_RUN=$(1); \
    PHP_CS_CONFIG_FILE="$$(pwd)/.php_cs"; \
    if [ ! -f "$${PHP_CS_CONFIG_FILE}" ]; then PHP_CS_CONFIG_FILE="$${PHP_CS_CONFIG_FILE}.dist"; fi; \
    CHANGED_FILES=$$(git cherry origin/master | cut -d " " -f 2 \
            | while read c; do git diff-tree --no-commit-id --name-only -r "$$c"; done \
            | sort | uniq \
            | while read f; do test -f "$$f" && echo "$$f"; done); \
    echo "$${CHANGED_FILES}" | sed '/./=' | sed '/./N; s/\n/\t/'; \
    echo "      ---------- check files ----------"; echo ""; \
    EXTRA_ARGS=$$(printf -- "--path-mode=intersection\n--\n%s" "$${CHANGED_FILES}"); \
    php-cs-fixer fix \
            --config=$${PHP_CS_CONFIG_FILE} \
            --using-cache=no \
            --format=txt -v \
            --diff-format=udiff \
            --diff $$DRY_RUN $$EXTRA_ARGS
endef

check-cs: ## Проверка стилей
	$(call check_code_style,--dry-run)
# -----------------

check-csf: ## Проверка стилей
	$(call check_code_style)
# -----------------

check-t:
	$(eval $(call get_diff_tree))
```


Или в bash версии

```bash
#!/bin/bash
WORKDIR=$(pwd)


DIR=$( cd $( dirname "${0}" ) && pwd )
if [ -h "${0}" ]; then
    cd "$DIR"
    DIR=$( cd $( dirname $( readlink $(basename "${0}") ) ) && pwd )
fi
DEFAULT_PHP_CS_CONFIG_FILE="${DIR}/.php_cs.dist"

PHP_CS_CONFIG_FILE="${WORKDIR}/.php_cs.dist"
if [ ! -f "${PHP_CS_CONFIG_FILE}" ]; then
        PHP_CS_CONFIG_FILE="${DEFAULT_PHP_CS_CONFIG_FILE}"
fi

IFS='
'

cd "${WORKDIR}"
#----------------------

ARGS="$@"

ARG_FIX="--dry-run"
if [[ $ARGS =~ "--fix" ]]; then
    ARGS=$(sed "s/--fix//g" <<<"$ARGS")
    ARG_FIX=""
fi

if [[ $ARGS =~ "--config=" ]]; then
    PHP_CS_CONFIG_FILE=$(sed 's/.*\?--config=\([^ ]\+\?\).*\?/\1/' <<<"$ARGS")
    ARGS=$(sed "s/--config=[^ ]\+\?[ ]*\?//g" <<<"$ARGS")
fi

__get_diff_files() # Список измененых файлов относительно ветки master
{
    local branch="origin/master"

    git cherry "$branch" | cut -d " " -f 2 \
      | while read c; do git diff-tree --no-commit-id --name-only -r "$c"; done \
      | sort | uniq \
      | while read f; do test -f "$f" && echo "$f"; done
    # git cherry "$branch" | cut -d " " -f 2 | xargs -I {} git diff-tree --no-commit-id --name-only -r {} \
    #     | sort | uniq \
    #     | while read f; do test -f "$f" && echo "$f"; done
}


if [ "x${ARGS}" = "x" ]; then
    CHANGED_FILES=$(__get_diff_files)

    echo "${CHANGED_FILES}" | sed '/./=' | sed '/./N; s/\n/\t/'
    echo "      ---------- check files ----------"

    EXTRA_ARGS=$(printf -- '--path-mode=intersection\n--\n%s' "${CHANGED_FILES}")
else
    EXTRA_ARGS=""
fi

if [ "x${EXTRA_ARGS}${ARGS}" != "x" ]; then
    php-cs-fixer fix \
    --config="${PHP_CS_CONFIG_FILE}" \
    --using-cache=no \
    --format=txt \
    -v \
    --diff-format=udiff \
    --diff $ARG_FIX $ARGS $EXTRA_ARGS
fi
```