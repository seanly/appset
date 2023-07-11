FROM maven:3-eclipse-temurin-8-alpine as p3c-builder

RUN apk add curl git 

WORKDIR /code

RUN git clone https://github.com/caowenliang/sonar-pmd-p3c /code && \
    mvn clean package -Dmaven.test.skip=true -pl sonar-pmd-plugin

FROM sonarqube:8.9.0-community

RUN apk add curl git 

RUN cd /opt/sonarqube/extensions/plugins; \
    curl -sLfO https://github.com/mc1arke/sonarqube-community-branch-plugin/releases/download/1.8.3/sonarqube-community-branch-plugin-1.8.3.jar && \
    curl -sLfO https://github.com/checkstyle/sonar-checkstyle/releases/download/9.3/checkstyle-sonar-plugin-9.3.jar && \
    curl -sLfO https://github.com/xuhuisheng/sonar-l10n-zh/releases/download/sonar-l10n-zh-plugin-8.9/sonar-l10n-zh-plugin-8.9.jar && \
    curl -sLfO https://github.com/spotbugs/sonar-findbugs/releases/download/4.2.3/sonar-findbugs-plugin-4.2.3.jar && \
    curl -sLfO https://github.com/vaulttec/sonar-auth-oidc/releases/download/v2.1.1/sonar-auth-oidc-plugin-2.1.1.jar && \
    curl -sLfO https://github.com/donhui/sonar-mybatis/releases/download/1.0.6/sonar-mybatis-plugin-1.0.6.jar && \
    curl -sLfO https://github.com/sbaudoin/sonar-shellcheck/releases/download/v2.5.0/sonar-shellcheck-plugin-2.5.0.jar && \
    curl -sLfO https://github.com/dependency-check/dependency-check-sonar-plugin/releases/download/3.1.0/sonar-dependency-check-plugin-3.1.0.jar

COPY --from=p3c-builder /code/sonar-pmd-plugin/target/sonar-pmd-plugin-3.2.1.jar /opt/sonarqube/extensions/plugins/

ENV SONAR_WEB_JAVAADDITIONALOPTS="-javaagent:/opt/sonarqube/extensions/plugins/sonarqube-community-branch-plugin-1.8.3.jar=web" \
    SONAR_CE_JAVAADDITIONALOPTS="-javaagent:/opt/sonarqube/extensions/plugins/sonarqube-community-branch-plugin-1.8.3.jar=ce"