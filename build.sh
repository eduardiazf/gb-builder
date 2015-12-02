#!/bin/bash -e

tagName=$1
DOCKERFILE=`find /project -name Dockerfile -type f`

if [ -z $tagName ];
then
  echo "Error: Must provide the name of the destination container";
  exit 1;
fi

if [ ! -e "/var/run/docker.sock" ];
then
  echo "Error: Must mount /var/lib/docker.sock";
  exit 1;
fi

if ( find /project -maxdepth 0 -empty | read v );
then
  echo "Error: Must mount Go source code into /project directory"
  exit 1;
fi

# compile
echo -e "Building `gb list` \n"
gb info && CGO_ENABLED=${CGO_ENABLED:-0} gb build

# Build app container
echo -e "\nBuilding container $tagName"
cd /app && cp /project/bin/* . && cp $DOCKERFILE .
docker build -t $tagName .
