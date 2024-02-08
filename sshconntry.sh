#!/bin/bash

echo -n "User: "
read SSH_USER

echo -n "Server: "
read SSH_SERVER

while [ true ]; do
    ssh $SSH_USER@$SSH_SERVER

    if [ $? -eq 0 ]; then
        break
    else
        echo "SSH connection failed. Retrying in 2 seconds..."
        sleep 2
    fi
done
