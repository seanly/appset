# codimd

## oauth2

https://github.com/hackmdio/codimd-docs/blob/master/misc/configuration.md#OAuth---General-OAuth2

配置地址参考：https://keycloak.example.cloud/realms/opsbox/.well-known/openid-configuration

```
    environment:
      - CMD_DEFAULT_PERMISSION=private
      - CMD_DOMAIN=codimd.example.cloud
      - CMD_PROTOCOL_USESSL=true
      - CMD_OAUTH2_CLIENT_ID=codimd
      - CMD_OAUTH2_CLIENT_SECRET=xxxx
      - CMD_OAUTH2_AUTHORIZATION_URL=https://keycloak.example.cloud/realms/opsbox/protocol/openid-connect/auth
      - CMD_OAUTH2_TOKEN_URL=https://keycloak.example.cloud/realms/opsbox/protocol/openid-connect/token
      - CMD_OAUTH2_BASEURL=https://keycloak.example.cloud
      - CMD_OAUTH2_USER_PROFILE_URL=https://keycloak.example.cloud/realms/opsbox/protocol/openid-connect/userinfo
      - CMD_OAUTH2_USER_PROFILE_USERNAME_ATTR=preferred_username
      - CMD_OAUTH2_USER_PROFILE_DISPLAY_NAME_ATTR=name
      - CMD_OAUTH2_USER_PROFILE_EMAIL_ATTR=email
      - CMD_OAUTH2_PROVIDERNAME=SSO
      - CMD_OAUTH2_SCOPE=openid email profile

    labels:
      - "traefik.http.routers.codimd.rule=Host(`codimd.example.dev`)"
      - "traefik.http.routers.codimd.tls=true"
      - "traefik.http.routers.codimd.tls.certResolver=le"
      - "traefik.http.services.codimd.loadbalancer.server.port=3000"
      - "traefik.http.routers.codimd.middlewares=codimd-login-redirect"
      - "traefik.http.middlewares.codimd-login-redirect.redirectregex.regex=^https://codimd.example.cloud/auth/email*"
      - "traefik.http.middlewares.codimd-login-redirect.redirectregex.replacement=https://codimd.example.cloud/auth/oauth2"
```