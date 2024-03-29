---
layout: post
title: Приостановите и разбудите ПК в определенное время
category: linux
tags: [doc, suspend,  sleep,  wakeup , linux]
summary: Приостановите и разбудите ПК в определенное время
---



[https://qastack.ru/ubuntu/113379/suspend-and-wake-pc-at-certain-time](https://qastack.ru/ubuntu/113379/suspend-and-wake-pc-at-certain-time)


Хотите перевести свой ПК с Linux в спящий режим или в режим гибернации, чтобы он автоматически включался в определенное время? Вы можете легко сделать это с помощью команды rtcwake, включенной по умолчанию в большинство систем Linux.


Это может быть полезно, если вы хотите, чтобы ваш компьютер что-то делал в определенное время, но не хотите, чтобы он работал 24/7. Например, вы можете перевести свой компьютер в ночное время и дать ему проснуться, прежде чем выполнять какие-либо загрузки.


## Использование `rtcwake`

Команде `rtcwake` требуются права суперпользователя, поэтому ее следует запускать с помощью sudo в Ubuntu и других производных от Ubuntu дистрибутивах. В дистрибутивах Linux, которые не используют sudo, вам сначала нужно войти в систему как пользователь root с помощью команды su.


Вот основной синтаксис команды:

`sudo rtcwake -m [type of suspend] -s [number of seconds]`


Например, следующая команда приостанавливает работу вашей системы на диске (переводит ее в спящий режим) и пробуждает через 60 секунд:

`sudo rtcwake -m disk -s 60`

Типы приостановки
`-m` коммутатор принимает следующие типы приостановки:

Режим ожидания - режим ожидания обеспечивает небольшую экономию энергии, но восстановление работающей системы происходит очень быстро. Это режим по умолчанию, если вы опустите ключ `-m`.

`mem` - приостановить в RAM. Это обеспечивает значительную экономию энергии - все находится в состоянии низкого энергопотребления, кроме вашей оперативной памяти. Содержимое вашей памяти сохраняется.

`disk` - приостановить на диск. Содержимое вашей памяти записывается на диск, и ваш компьютер выключается. Компьютер включится и его состояние будет восстановлено после завершения работы таймера.

`off` - полностью выключить компьютер. Справочная страница `rtcwake` отмечает, что восстановление из «off» официально не поддерживается спецификацией ACPI, но в любом случае это работает на многих компьютерах.

`no` - не выключайте компьютер немедленно, просто установите время пробуждения. Например, вы можете попросить свой компьютер проснуться в 6 утра. После этого можно положить его спать вручную в 11 вечера или 1 утра - в любом случае, он проснется в 6 утра.

Секунды против определенного времени.


Опция `-s` в будущем займет несколько секунд. Например, `-s 60` разбудит компьютер за 60 секунд, а `-s 3600` разбудит компьютер за час.

Опция `-t` позволяет вам разбудить компьютер в определенное время. Этому переключателю требуется несколько секунд с начала эпохи Unix (00:00:00 UTC 1 января 1970 года). Чтобы легко указать правильное количество секунд, объедините команду date с командой `rtcwake`.

`-L` переключатель указывает `rtcwake` , что аппаратные часы установлены по местному времени, в то время как `-u` переключатель указывает `rtcwake` , что аппаратные часы (в BIOS вашего компьютера) установлен в UTC время. Дистрибутивы Linux часто устанавливают ваши аппаратные часы на время UTC и переводят их в ваше местное время.

Например, чтобы компьютер проснулся завтра в 6:30 утра, но не остановился сразу (при условии, что ваши аппаратные часы настроены на местное время), выполните следующую команду:

```bash
sudo rtcwake -m no -l -t $(date +%s -d ‘tomorrow 06:30’)
```
