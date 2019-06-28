#!/bin/bash

if ! hash docker 2> /dev/null; then
    echo "Docker is not installed.."
else
    if ! sudo systemctl status docker > 0; then
        echo "Docker service is inactive, starting it.."
        sudo systemctl start docker
    fi

    echo "Prepare to destroy all containers.."
    for container in $(sudo docker ps -a | grep -v '^CONTAINER' | awk '{print$1}'); do
        echo "Destroying container: $container" 
        sudo docker rm "$container" 
    done

    echo "Stopping the Docker daemon"
    sudo systemctl stop docker
fi
