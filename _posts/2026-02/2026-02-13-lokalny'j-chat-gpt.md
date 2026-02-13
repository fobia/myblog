---
layout: post
title:  "Локальный чат gpt"
tags: [doc]
---

#### Настройте производственный репозиторий:

```sh
sudo apt-get update && sudo apt-get install -y --no-install-recommends \
   curl \
   gnupg2

curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey  | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

При желании можно настроить репозиторий для использования экспериментальных пакетов:

```sh
sudo sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list`
sudo apt-get update
```

Установите пакеты NVIDIA Container Toolkit:

```sh
export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.18.1-1
sudo apt-get install -y \
      nvidia-container-toolkit=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      nvidia-container-toolkit-base=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container-tools=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container1=${NVIDIA_CONTAINER_TOOLKIT_VERSION}
```


#### Конфигурация

Настройка Docker 
Настройте среду выполнения контейнера с помощью nvidia-ctk команды:

```sh
sudo nvidia-ctk runtime configure --runtime=docker
```

Эта nvidia-ctk команда изменяет `/etc/docker/daemon.json` файл на хосте. Файл обновляется, чтобы Docker мог использовать среду выполнения контейнеров NVIDIA.

Перезапустите демон Docker:

```sh
sudo systemctl restart docker

sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
```


Запускаем чат

```sh
docker run -d -p 3000:8080 --gpus all -v open-webui:/app/backend/data --name open-webui ghcr.io/open-webui/open-webui:ollama
```

### qwen3:8b