ARG KEYCLOAK_VERSION=22.0.5
FROM alpine:3 as build

RUN apk update && apk add curl

ARG KEYCLOAK_VERSION=22.0.5
ENV KEYCLOAK_VERSION=${KEYCLOAK_VERSION}
WORKDIR /providers/
RUN mkdir -p /packages/ && \
    curl -sLfO https://github.com/jacekkow/keycloak-protocol-cas/releases/download/${KEYCLOAK_VERSION}/keycloak-protocol-cas-${KEYCLOAK_VERSION}.jar

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

COPY --from=build /providers/ /opt/keycloak/providers/
RUN /opt/keycloak/bin/kc.sh build