#!/bin/bash

echo "Do you want to install Docker? (y/n)"
read docker
if [ "$docker" = "y" ]; then
    echo "Installing Docker..."
    echo $docker
    echo "Docker installed successfully"
else
    echo "Docker installation skipped"
fi
