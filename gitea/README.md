# Gitea

## 使用注意

下面的配置主要是实现当访问 `/usr/login` 请求时重定向到首页，但是当访问首页时会重定向到 `/user/oauth2/sso` 单点登录页面，这样就实现了只允许单点登录方式。

如果需要手动登录本地账号需要修改下面的 `xxx.replacement=https://gitea.opsbox.dev/user/login`，然后手动访问这个地址。

```
    environment:
      - GITEA__server__LANDING_PAGE=/user/oauth2/sso
    labels:
    - "traefik.http.routers.gitea.middlewares=gitea-login-redirect"
    - "traefik.http.middlewares.gitea-login-redirect.redirectregex.regex=^https://gitea.opsbox.dev/user/login*"
    - "traefik.http.middlewares.gitea-login-redirect.redirectregex.replacement=https://gitea.opsbox.dev/"
```

## 配置说明

所有配置参考 [Gitea 配置说明](https://docs.gitea.com/zh-cn/administration/config-cheat-sheet)，主要说明以下几个变量的配置意义：

1. 取消 OpenID 的登录和注册，这个感觉没啥用。

- GITEA__openid__ENABLE_OPENID_SIGNIN=false
- GITEA__openid__ENABLE_OPENID_SIGNUP=false

2. 取消 ssh 协议，配置过于复杂，HTTPS 协议也已经够用。

- GITEA__server__DISABLE_SSH=false

3. 限制登录方式，通过 keycloak 的功能实现相关登录的安全要求。

- GITEA__server__LANDING_PAGE=/user/oauth2/sso

4. 取消本地账号注册，新用户创建通过 keycloak 进行管理。

- GITEA__service__DISABLE_REGISTRATION=true
- GITEA__service__ENABLE_CAPTCHA=true
- GITEA__service__ENABLE_BASIC_AUTHENTICATION=false
- GITEA__service__REQUIRE_CAPTCHA_FOR_LOGIN=true
- GITEA__service__REQUIRE_EXTERNAL_REGISTRATION_CAPTCHA=true
- GITEA__service__ALLOW_ONLY_EXTERNAL_REGISTRATION=true

- GITEA__oauth2_client__ENABLE_AUTO_REGISTRATION=true
- GITEA__oauth2_client__USERNAME=username
- GITEA__oauth2_client__ACCOUNT_LINKING=auto

5. 限制组织的创建，组织需要由管理人员负责创建。

- GITEA__admin__DISABLE_REGULAR_ORG_CREATION=true

