FROM golang:1.5
MAINTAINER Eduardo Diaz <eduardiazf@gmail.com>

ENV GBVERSION v0.3.2
ENV DOCKER_VERSION 1.9.0

RUN mkdir -p /app
RUN apt-get update

# Install Docker binary
RUN wget -nv https://get.docker.com/builds/Linux/x86_64/docker-$DOCKER_VERSION \
	-O /usr/bin/docker && chmod +x /usr/bin/docker

RUN mkdir -p $GOPATH/src/github.com/constabulary && \
      cd $GOPATH/src/github.com/constabulary && \
      git clone https://github.com/constabulary/gb.git && \
      cd gb && \
      git checkout $GBVERSION && \
      go install -v ./... && \
      cd $GOPATH && \
      rm -rf src pkg

COPY build.sh /
RUN chmod +x /build.sh

WORKDIR /src
ENTRYPOINT ["/build.sh"]
