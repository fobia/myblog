---
layout: post
title: PHPstorm WSL2 Project
category: Media
tags: [WSL2, PHPStorm, linux]
summary: Запускаем PHPStorm из под WSL2
---

### Запускаем PHPStorm из под WSL2

Preparing Windows and WSL2 for GUI applications

### Windows

For Windows, it is quite simple.


One prerequisite is WSL2, which is standard in Windows 2004 (May update 2020).


If you do not know how to install WSL2, you can read this guide: Linux on Windows? Totally! How to Install WSL 1 and WSL 2.


The second thing is, that we need an X Server for Windows.


A simple and free solution is [VcXsrv](https://sourceforge.net/projects/vcxsrv/).


If it is installed, you can start it. In the opened dialog you have to choose:


Page “Display settings”:

- “Multiple windows”
- “Display number”: -1
  
Page “Client startup”:

- “Start no client”

Page “Extra settings”

- Activate all (including “Disable access control”).


Page “Finish configuration”

- It is a good idea to save the configuration as a Desktop icon because then you simply can click this launcher in the future and you do not have to reconfigure it again and again.


Recommendation: If your PC does not have a static IP address, try to make it static (fixed DNS or static entry in your network settings). This is very important for a seamless work with the X server. Else you have to repeat the same steps again and again (see next section).


### WSL2 (Ubuntu 20)
First change to your home directory with a simple “cd”.


The most important thing here is the export of the display. For that, you need to know the LAN IP address of your PC in Windows. As mentioned in the previous section, it is very helpful, if this IP is static.


For the first try, you can export the display directly in the WSL2 shell:
This works with

```bash
export WSL_ip_line=$(ipconfig.exe | grep "WSL" -n | awk -F ":" '{print $1+4}')
export DISPLAY=$(ipconfig.exe | awk -v a=$WSL_ip_line '{if (NR==a) print $NF":0.0"}' | tr -d "\r")
```

or it can be necessary to export it to the real host IP:

```bash
export DISPLAY=192.168.0.160:0.0
```


The IP address here is the host IP address under Windows of the PC.


It is also a good idea to export the LIBGL_ALWAYS_INDIRECT value:


```bash
export LIBGL_ALWAYS_INDIRECT=1
```

If you have a static address and if you want to use it often, it is a good idea to add this “export” to your “.bashrc” or “.zshrc” (or whatever your shells default is) file, that it will be available after every login.


For IntelliJ and the Jetbrains toolbox, I had to install also the following things:


```bash
sudo apt install libcups2 libpangocairo-1.0-0 libatk-adaptor libxss1 libnss3 libxcb-keysyms1 x11-apps libgbm1
```


Not all are necessary for IntelliJ itself, but I used the Jetbrains Toolbox to install IntelliJ, which makes it easier with upgrades.


Now you can go to the Jetbrains Toolbox page and find out the download for Linux.


Choose “Linux (tar.gz)” for the download. If the download wants to start cancel it and copy the “Direct link” from the page.


On the WSL2 shell, you can now download the Toolbox with “wget”. After this is finished, extract the application with

```bash
tar -zxf jetbrains-toolbox-*.tar.gz
```


Now go to the new “jetbrains-toolbox” directory and execute the toolbox application inside:

```bash
./jetbrains-toolbox
```


If you have started the VcXsrv before, the Toolbox window should now open and you can install “IntelliJ” and the other tools. I was unable to log in on the Toolbox directly to my Jetbrains account, but this is not a problem, because the login in the IDE is working.


For easy access to the Jetbrains applications you should also go to the Toolbox settings and enable the “Shell Scripts” feature. I’ve added “~/jb/” to the location. Then Toolbox creates a start script in this directory for each application.
I’ve also created a new script called “toolbox” to this directory, that contains the following:

```bash
#!/bin/bash
~/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox
```


### Remote ssh server


1. Качаем с официального сайта или напрямую с SourceForge
2. Устанавливаем
3. Настраиваем, запускаем Пуск -> Все программы -> Xming ->XLaunch

Выбираем Multiple windows и устанавливаем Display number таким же, как было настроено в PuTTY:

Нажимаем Далее и выбираем Start no client, тогда Xming «поселится» в трее и будет ждать, пока мы с консоли PuTTY запустим какое-нибудь графическое приложение.

Чтобы каждый раз не лезть в XLaunch, можно в свойства ярлыка Xming дописать нужные параметры `"C:\Program Files\Xming\Xming.exe" :0 -clipboard -multiwindow`


Борьба с шрифтами проста. Дописываем в окне Additional Parameters XLaunch’а в строку Additional parameters for Xming параметр -dpi 96 или его же в свойства ярлыка. Число в параметре выбираем под свои глаза и монитор  `"C:\Program Files\Xming\Xming.exe" :0 -clipboard -multiwindow  -dpi 96`


На серваке:

```
sudo apt-get install xauth -y
```

Правим конфиг `vim /etc/ssh/sshd_config`

```
X11Forwarding yes
X11DisplayOffset 10
X11UseLocalhost no
```


Перезапускаем демон или рестартируем сервер.

```
# systemctl restart ssh.service
```


Если надо, открываем порты на файерволе:
Для переопределения дисплея:

```
iptables -A INPUT -s x.x.x.x/xx -p tcp --dport 6000 -j ACCEPT
iptables -A OUTPUT -s x.x.x.x/xx -p tcp --sport 6000 -j ACCEPT
```


Вместо x.x.x.x/xx подставить нужную подсеть

```
sudo iptables -A INPUT -s 192.168.0.1/24 -p tcp --dport 6000 -j ACCEPT
sudo iptables -A OUTPUT -s 192.168.0.1/24 -p tcp --sport 6000 -j ACCEPT
```


Теперь конектимся c флагом `-X`

```
$ ssh -X remote_ssh_user@remote_server
```


Если не работает, проверяем переменую `DISPLAY`, она должна существовать

```
echo $DISPLAY
# localhost:10.0
```


export DISPLAY=192.168.0.160:3.02021-01-3