# codimd

## oauth2

https://github.com/hackmdio/codimd-docs/blob/master/misc/configuration.md#OAuth---General-OAuth2

配置地址参考：https://keycloak.example.cloud/realms/opsbox/.well-known/openid-configuration

```
    environment:
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
```