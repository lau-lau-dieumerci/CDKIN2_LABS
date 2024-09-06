#!/bin/bash
sudo dnf install nodejs
node --version
curl -o- https://nodejs.org/dist/latest/node-v22.3.0-linux-x64.tar.xz | sudo tar -xJf - -C /usr/local --strip-components=1
node --version
