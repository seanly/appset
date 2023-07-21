FROM registry:2.8.1

LABEL cloud.opsbox.authors="seanly" \
      cloud.opsbox.email="seanly@opsbox.dev" \
      cloud.opsbox.name="registry" \
      cloud.opsbox.version="2.8.1"

RUN apk update && \
    apk add --no-cache neovim busybox-extras bash tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
