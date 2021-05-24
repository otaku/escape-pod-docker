# Dockerized Escape Pod

Available on Docker Hub under `alex/escape-pod`

Docker Volumes

* `/data/db`
* `/usr/local/escapepod/ui/ota`

Docker Environment variables

* DDL_DB_NAME
* DDL_DB_HOST
* DDL_DB_PORT
* DDL_DB_USERNAME
* DDL_DB_PASSWORD
* DDL_SAYWHATNOW_STT_POOL_SIZE
* PI_ESCAPEPOD_HOST

Notes:

* MongoDB initialization will happen if /data/db is empty.
* You must publish mdns for `escapepod.local`

If running a pi for BLE / onboarding:

* `echo escapepod-pi | sudo tee /etc/hosts`
* `echo ESCAPEPOD-CONTAINER-IP escapepod.local | sudo tee /etc/avahi/hosts`
* `sudo reboot`

The following files must be extracted from the image to the current directory before building the docker image:

* `/usr/local/escapepod/bin`
* `/usr/local/escapepod/ui`
* dump directory output from mongodump

`docker-compose.yml` example:

```
services:
  escapepod:
    restart: unless-stopped
    image: alex/escape-pod
    environment:
      - PI_ESCAPEPOD_HOST=192.168.1.150
    volumes:
      - ./escape-pod-dump:/usr/local/escapepod/dump
      - escapepod:/data/db
```

Generate a MongoDB binary export

* `mongo --eval 'db.getSiblingDB("admin").createUser({ user: "backup", pwd: "password", roles: [ "backup" ] })'`
* `mongodump -u backup -p password -o dump/`

Remove escapepod.local domain

* `patch ui/webpack.js ui.patch`

Running arm64v8 image on a different architecture:

https://hub.docker.com/r/multiarch/qemu-user-static/

* `docker run --rm --privileged multiarch/qemu-user-static --reset`
