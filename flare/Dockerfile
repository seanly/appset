FROM golang:1.21.0-alpine3.18 AS Builder

RUN apk update && \
    apk add --update --no-cache curl git wget \
        git bash gcc musl-dev upx

ENV GO111MODULE=on
ENV CGO_ENABLED=0

WORKDIR /flare

RUN git clone --depth 1 https://github.com/seanly/flare.git /flare

RUN set -eux \
    ; OS="$(uname | tr '[:upper:]' '[:lower:]')" \
    ; ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" \
    ; cd /flare\
    ; go mod download\
    ; go run build/build.go\
    ; export BUILD_DATE=`date +%FT%T%z`\
    ; GOARCH=${ARCH} go build -ldflags "-w -s -X 'github.com/soulteary/flare/internal/version.Version=main' -X 'github.com/soulteary/flare/internal/version.Commit=main' -X 'github.com/soulteary/flare/internal/version.BuildDate=$BUILD_DATE'" -o flare main.go

FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]
RUN apt-get update && \
    apt install -y apt-transport-https ca-certificates curl wget xz-utils

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt install -y --no-install-recommends tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata

WORKDIR /app

COPY --from=Builder /flare/flare /bin/flare

CMD ["flare"]