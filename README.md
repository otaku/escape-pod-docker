# Dockerized Escape Pod

Avaiable on Docker Hub under `alex/escape-pod`

Docker Volumes

* `/data/db`
* `/usr/local/escapepod/ui/ota`

Note: MongoDB initialization will happen if /data/db is empty.

The following files must be extracted from the image to the current directory before building the docker image:

* `/usr/local/escapepod/bin`
* `/usr/local/escapepod/ui`
* dump directory output from mongodump

Generate a MongoDB binary export

* `mongo --eval 'db.getSiblingDB("admin").createUser({ user: "backup", pwd: "password", roles: [ "backup" ] })'`
* `mongodump -u backup -p password -o dump/`

Remove escapepod.local domain

* `patch ui/webpack.js ui.patch`

Running arm64v8 image on a different architecture:

https://hub.docker.com/r/multiarch/qemu-user-static/

* `docker run --rm --privileged multiarch/qemu-user-static --reset`
