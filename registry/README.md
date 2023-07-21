# registry

## docker config

file: /etc/docker/daemon.json

```json
"insecure-registries": ["<ip>:<port>"]

```

## auth

```bash

yum install -y httpd-tools

mkdir -p auth
htpasswd -Bbn admin admin > auth/htpasswd

```

