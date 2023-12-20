FROM alpine as pkg

RUN apk add curl git 

WORKDIR /pkg 

RUN set -eux; \
    mkdir -p /tmp/pkg; cd /tmp/pkg;\
    curl -sLfO https://github.com/LuaJIT/LuaJIT/archive/refs/tags/v2.0.5.tar.gz && \
    curl -sLfO https://github.com/openresty/luajit2/archive/refs/tags/v2.1-20210510.tar.gz && \
    curl -sLfO https://github.com/xudianyang/nginx-logid/archive/refs/tags/v1.0.0.tar.gz && \
    curl -sLfO https://github.com/vozlt/nginx-module-vts/archive/refs/tags/v0.2.2.tar.gz && \
    curl -sLfO https://github.com/vision5/ngx_devel_kit/archive/refs/tags/v0.3.2.tar.gz && \
    curl -sLfO https://github.com/calio/form-input-nginx-module/archive/refs/tags/v0.12.tar.gz && \
    curl -sLfO https://github.com/alibaba/tengine/archive/refs/tags/2.4.1.tar.gz

RUN set -eux; \
  mkdir -p /pkg \
  && ls /tmp/pkg/*.tar.gz | xargs -I {} tar -xzf {}  -C /pkg

FROM seanly/toolset:brew as build

RUN \
  set -xe && \
  apt update && \
  apt install -y git vim gcc bzip2 make autoconf perl \
       libpcre3 libpcre3-dev openssl libssl-dev zlib1g-dev libgd-dev

COPY --from=pkg /pkg /pkg

RUN set -eux; \
  cd /pkg/luajit2-2.1-20210510; \
  make && make install; \
  cp /usr/local/lib/libluajit-5.1.so* /usr/lib64; \
  cp -rf /usr/local/include/luajit-2.1 /usr/include 

RUN set -eux; \
    mkdir -p /var/tmp/client_body;  \
    mkdir -p /usr/local/nginx/var/tmp/proxy;  \
    mkdir -p /usr/local/nginx/var/fastcgi;  \
    mkdir -p /usr/local/nginx/var/uwsgi;  \
    mkdir -p /var/log/nginx;  \
    mkdir -p /var/cache/nginx; \
    cd /pkg/tengine-2.4.1; \
    ./configure --prefix=/usr/local/nginx \
      --pid-path=/var/run/nginx.pid \
      --error-log-path=/var/log/nginx/error.log \
      --http-log-path=/var/log/nginx/access.log \
      --http-client-body-temp-path=/var/tmp/client_body \
      --http-proxy-temp-path=/usr/local/nginx/var/tmp/proxy \
      --http-fastcgi-temp-path=/usr/local/nginx/var/fastcgi \
      --http-uwsgi-temp-path=/usr/local/nginx/var/uwsgi  \
      --with-file-aio \
      --with-http_ssl_module \
      --with-http_v2_module \
      --with-http_realip_module \
      --with-http_addition_module \
      --with-http_image_filter_module \
      --with-http_gunzip_module \
      --with-http_gzip_static_module \
      --with-http_auth_request_module \
      --with-http_stub_status_module \
      --with-http_sub_module \
      --with-pcre \
      --without-http_ssi_module \
      --without-http_userid_module \
      --without-http_split_clients_module \
      --without-http_uwsgi_module \
      --without-http_memcached_module \
      --without-http_geo_module \
      --without-http_scgi_module \
      --without-mail_pop3_module \
      --without-mail_imap_module \
      --without-mail_smtp_module \
      --with-http_lua_module \
      --with-luajit-lib=/usr/local/lib/ \
      --with-luajit-inc=/usr/local/include/luajit-2.1/ \
      --with-lua-inc=/usr/local/include/luajit-2.1/ \
      --with-lua-lib=/usr/local/lib/ \
      --with-ld-opt=-Wl,-rpath,/usr/local/lib \
      --add-module=/pkg/nginx-logid-1.0.0 \
      --add-module=/pkg/ngx_devel_kit-0.3.2 \
      --add-module=/pkg/form-input-nginx-module-0.12 \
    && make -j 4 && make install

FROM seanly/toolset:s6-overlay

COPY --from=build /usr/local/nginx /usr/local/nginx
COPY --from=build /usr/local/lib /usr/local/lib
COPY --from=build /usr/local/include /usr/local/include

RUN \
  set -xe && \
  apt update && \
  apt install -y git vim bzip2 \
       libpcre3 libpcre3-dev openssl libssl-dev zlib1g-dev jq python3 python3-pip python3.10-venv \
  && mkdir -p /var/run \
  && mkdir -p /var/log/nginx \
  && mkdir -p /var/cache/nginx/proxy \
  && mkdir -p /var/cache/nginx/fastcgi \
  && mkdir -p /var/cache/nginx/client_body \
  && ln -s /dev/stdout /var/log/nginx/access.log  \
  && ln -s /dev/stderr /var/log/nginx/error.log  \
  && chown -R ${uid}:${gid} /var/cache/nginx \
  && chown -R ${uid}:${gid} /var/log/nginx \
  && chown -R ${uid}:${gid} /usr/local/nginx 

RUN \
  echo "**** install certbot plugins ****" && \
  CERTBOT_VERSION=$(curl -sL  https://pypi.python.org/pypi/certbot/json |jq -r '. | .info.version') && \
  python3 -m venv /lsiopy && \
  pip install -U --no-cache-dir \
    pip \
    wheel && \
  pip install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine-3.18/ \
    certbot==${CERTBOT_VERSION} \
    certbot-dns-aliyun \
    certbot-dns-dnspod \
    cryptography \
    future \
    zope \
    requests

WORKDIR /usr/local/nginx

EXPOSE 80 443

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

STOPSIGNAL SIGTERM

ENV PATH /usr/local/nginx/sbin:$PATH

COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf

# add local files
COPY rootfs /

ENTRYPOINT ["/init"]
