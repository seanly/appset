#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/"

docker-compose stop registry
docker-compose run --rm registry bin/registry garbage-collect /etc/docker/registry/config.yml
docker-compose up -d registry
