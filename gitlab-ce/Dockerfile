FROM alpine as omnibus-gitlab

#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk update && apk add --update --no-cache curl git wget

RUN git clone https://gitlab.com/gitlab-org/omnibus-gitlab.git /omnibus-gitlab

FROM ubuntu:22.04
MAINTAINER GitLab Inc. <support@gitlab.com>

SHELL ["/bin/sh", "-c"]

# Default to supporting utf-8
ENV LANG=C.UTF-8

# Install required packages
RUN apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      busybox \
      ca-certificates \
      openssh-server \
      tzdata \
      wget \
      perl \
      libperl5.34 \
      libatomic1 \
    && rm -rf /var/lib/apt/lists/*

# Use BusyBox
ENV EDITOR /bin/vi
RUN busybox --install \
    && { \
        echo '#!/bin/sh'; \
        echo '/bin/vi "$@"'; \
    } > /usr/local/bin/busybox-editor \
    && chmod +x /usr/local/bin/busybox-editor \
    && update-alternatives --install /usr/bin/editor editor /usr/local/bin/busybox-editor 1

# Remove MOTD
RUN rm -rf /etc/update-motd.d /etc/motd /etc/motd.dynamic
RUN ln -fs /dev/null /run/motd.dynamic

# Legacy code to be removed on 17.0.  See: https://gitlab.com/gitlab-org/omnibus-gitlab/-/merge_requests/7035
ENV GITLAB_ALLOW_SHA1_RSA=false


ARG VERSION=16.7.0-ce.0

RUN set -eux \
    ; OS="$(uname | tr '[:upper:]' '[:lower:]')" \
    ; ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" \
    ; echo "DOWNLOAD_URL=https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/jammy/gitlab-ce_${VERSION}_${ARCH}.deb/download.deb" > /RELEASE

COPY --from=omnibus-gitlab /omnibus-gitlab/docker/assets/ /assets/
# as gitlab-ci checks out with mode 666 we need to set permissions of the files we copied into the
# container to a secure value. Issue #5956
RUN chmod -R og-w /assets RELEASE ; \
  /assets/setup

# Allow to access embedded tools
ENV PATH /opt/gitlab/embedded/bin:/opt/gitlab/bin:/assets:$PATH

# Resolve error: TERM environment variable not set.
ENV TERM xterm

# Expose web & ssh
EXPOSE 443 80 22

# Define data volumes
VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]

# Wrapper to handle signal, trigger runit and reconfigure GitLab
CMD ["/assets/wrapper"]

HEALTHCHECK --interval=60s --timeout=30s --retries=5 \
CMD /opt/gitlab/bin/gitlab-healthcheck --fail --max-time 10
