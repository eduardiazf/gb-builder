#!/bin/bash -e

tagName=$1
DOCKERFILE=`find /src -name Dockerfile -type f`

if [ -z $tagName ];
then
  echo "Error: Must provide the name of the destination container";
  exit 1;
fi

if [ -z $APP ];
then
  echo "Error: Must provide the name of the app";
  exit 1;
fi

if [ ! -e "/var/run/docker.sock" ];
then
  echo "Error: Must mount /var/lib/docker.sock";
  exit 1;
fi

if ( find /src -maxdepth 0 -empty | read v );
then
  echo "Error: Must mount Go source code into /src directory"
  exit 1;
fi

# compile
echo "Building $APP"
gb info && CGO_ENABLED=${CGO_ENABLED:-0} gb build

# Build app container
cd /app && cp /src/bin/$APP . && cp $DOCKERFILE .
docker build -t $tagName .
