FROM debian:stretch

RUN set -eux \
    ; echo 'Acquire::AllowInsecureRepositories "true";' >> /etc/apt/apt.conf.d/insecure-repo \
    ; echo 'Acquire::AllowDowngradeToInsecureRepositories "true";' >> /etc/apt/apt.conf.d/insecure-repo \
    ; sed -i 's;http://deb.debian.org/debian;http://archive.debian.org/debian;g' /etc/apt/sources.list \
    ; sed -i 's;http://security.debian.org/debian-security;http://archive.debian.org/debian-security;g' /etc/apt/sources.list \
    ; sed -i '/stretch-updates/d' /etc/apt/sources.list \
    ;apt-get update -y && apt install vim wget lsb-release curl procps net-tools telnet git -y

ENV DATAROOTDIR=/usr/share
ENV SYSCONFDIR=/etc

WORKDIR /opt/ldapcherry

RUN git clone -b master https://github.com/seanly/ldapcherry /opt/ldapcherry

RUN set -eux \
    ;apt install -y python-dev python-pip libldap2-dev libsasl2-dev libssl-dev && \
    pip install -e /opt/ldapcherry/ -r /opt/ldapcherry/requirements-stretch.txt pycodestyle passlib coveralls configparser in_place && \
    /usr/bin/python2 /opt/ldapcherry/setup.py install

VOLUME /etc/ldapcherry
EXPOSE 8080

ENTRYPOINT ldapcherryd -c /etc/ldapcherry/ldapcherry.ini
