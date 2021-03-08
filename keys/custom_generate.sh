#!/usr/bin/env bash

_MSYSTEM="MINGW64"
set -e -u

cd $(dirname $0)

WORK_DIR="/c/workspace/concourse-docker"
_MSYSTEM=""
if [ "$_MSYSTEM" == "MINGW64" ]; then
  WORK_DIR="$(cygpath -t windows $(pwd))"
fi

sleep 10

echo "$WORK_DIR"

docker run --rm -v "C:\workspace\concourse-docker\web":/keys concourse/concourse generate-key -t rsa -f /keys/session_signing_key

docker run --rm -v "C:\workspace\concourse-docker\web":/keys concourse/concourse generate-key -t ssh -f /keys/tsa_host_key

docker run --rm -v "C:\workspace\concourse-docker\worker":/keys concourse/concourse generate-key -t ssh -f /keys/worker_key

cp ./worker/worker_key.pub ./web/authorized_worker_keys
cp ./web/tsa_host_key.pub ./worker
