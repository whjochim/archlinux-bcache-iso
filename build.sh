#!/bin/sh
docker build . -t archlinux-bcache-iso
docker run -v /tmp:/tmp -t -i --privileged archlinux-bcache-iso:latest
cp /tmp/archlinux*.iso .
