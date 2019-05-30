FROM debian:stable-slim
ARG NGINX_VERSION=1.12.1
ARG PATCH_FILE=proxy_connect_rewrite.patch
WORKDIR /app

RUN set -e; \
    apt-get update; \
    apt-get -y install \
        build-essential \
        gettext-base \
        libpcre3 \
        libpcre3-dev \
        libssl-dev \
        patch \
        unzip \
        wget \
        zlib1g-dev \
    ;
RUN set -e; \
    cd /tmp; \
    wget -O ngx_http_proxy_connect_module.zip https://github.com/chobits/ngx_http_proxy_connect_module/archive/master.zip; \
    unzip ngx_http_proxy_connect_module.zip;
RUN set -e; \
    wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz; \
    tar -xzvf nginx-${NGINX_VERSION}.tar.gz; \
    cd nginx-${NGINX_VERSION}; \
    wget https://raw.githubusercontent.com/chobits/ngx_http_proxy_connect_module/master/patch/proxy_connect_rewrite.patch; \
    patch -p1 < /tmp/ngx_http_proxy_connect_module-master/patch/${PATCH_FILE}; \
    ./configure \
        --add-module=/tmp/ngx_http_proxy_connect_module-master \
        --with-http_ssl_module \
        --with-http_slice_module \
        --sbin-path=/usr/local/sbin/nginx \
        --conf-path=/etc/nginx/conf/nginx.conf \
        --pid-path=/run/nginx.pid \
        --error-log-path=stderr \
        --http-log-path=/var/log/nginx/access.log; \
    make && make install;
RUN ln -sf /dev/stdout /var/log/nginx/access.log

COPY docker-entrypoint.sh /usr/local/bin/
COPY ./certs/* ./conf/* /etc/nginx/conf/

VOLUME [ "/data" ]
EXPOSE 3128
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["run-proxy"]
