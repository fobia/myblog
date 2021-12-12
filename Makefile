#!/usr/bin/make -f
# SHELL = /bin/sh

###########################################################
### About Makefile                                      ###
###########################################################
###
### Установка команды make для Windows.
###	  Из документации (https://gist.github.com/evanwill/0207876c3243bbb6863e65ec5dc3f058#make)
###    - Go to ezwinports (https://sourceforge.net/projects/ezwinports/files/make-4.2.1-without-guile-w32-bin.zip/download).
###    - Download make-4.1-2-without-guile-w32-bin.zip (get the version without guile).
###    - Extract zip.
###    - Copy the contents to your Git\mingw64\ merging the folders, but do NOT overwrite/replace any existing files.
###
###
### Не забудте указать путь директории в переменной PATH
###  Нажмите Ctr+R и введите SystemPropertiesAdvanced.exe, нажмите "переменные среды"
###  и добавте в переменную Path
###  значение "C:\Program Files\Git\mingw64\bin"
###
###
###
###########################################################

# Установите директории проектов (относительные или абсолютные пути)
# Для Windows пути нужно указывать с разделителем nix "/",
#   APP_DIR=C:/Users/user/Documents/app
#
#APP_DIR=/home/user/Projects/app
## ===============================================

#CMD_PREFIX := $(shell echo $$(test "$$(expr substr $$(uname -s) 1 5)" = "MINGW" && echo "winpty" || echo "") )

#.ONESHELL:
SHELL = /bin/bash
.DEFAULT_GOAL = help

.TEMP_MAKEFILE=.Makefile-run-once.tmp

.PHONY: help php-build down dc-up dc-down dc-build
## ===============================================

DC=
COPY=cp     # Команда копирования
# For windows
#COPY=copy  # Если Windows (оболочка CMD), то сменим на его команду
ifeq ($(origin SHLVL), undefined)
	OS_TYPE=Windows
	COPY=copy
else
	ifeq ($(shell expr substr $$(uname -s) 1 5), MINGW)
		DC=winpty
	endif
endif

help:
	@echo "Usage: "
	@sed -e '/^[a-zA-Z].\+:.\+#/!d' -e 's/^\(.\+\?\):.\+\?## /\1:/' Makefile | awk -F: '{ printf "  %-20s %s\n", $$1, $$2 }'
	@echo;
	@echo 'Для запуска команд в докере нужно добавить префикс dc. к команде'
	@echo 'Пример make dc.php-update-elastic'

all:
	help
# -----------------

start: ## Запустить
	bundle exec jekyll serve -i

tags: ## Сгенерировать теги
	bash blog-cli.sh tags


commit: ## Закомитить все
	git commit -am '----'
	git push origin



build: ## Сбилдить проект
	# bundle exec jekyll build
	bash blog-cli.sh tags -c
	git commit -am '----'
	git push origin

docker-build: ## Сбилдить docker
	docker build -t myblog .

docker-start: ## Запустить через docker
	docker run -it --rm -p 4000:4000 -v $$(pwd):/srv/jekyll myblog make start
