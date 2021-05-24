#!/usr/bin/env bash

set -euxo pipefail

INIT_MONGO=

if [[ "${DDL_DB_HOST}" == "127.0.0.1" ]]
then
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
fi

sed -i "s/PI_ESCAPEPOD_HOST/${PI_ESCAPEPOD_HOST}/" /usr/local/escapepod/ui/webpack.js

exec "/usr/local/escapepod/bin/escape-pod"
