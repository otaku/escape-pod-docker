#!/usr/bin/env bash

set -euxo pipefail

INIT_MONGO=0

# Check for file existance
if [[ ! -f "/data/db/storage.bson" ]]
then
  INIT_MONGO=true
fi

mongod --replSet rs0 &

if [[ "${INIT_MONGO}" == "true" ]]
then
  until mongo --eval 'rs.initiate()'; do sleep 3; done && \
  mongorestore /usr/local/escapepod/dump/
fi

exec "/usr/local/escapepod/bin/escape-pod"
