#!/usr/bin/env bash
set -e

export NAMESERVER="${NAMESERVER:-`cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}' | tr '\n' ' '`}"
export PROXY_MAX_SIZE="${PROXY_MAX_SIZE:-2g}"

if [ "$1" = 'run-proxy' ]; then
    shift
    for template_file in `find /etc/nginx/conf/ -iname '*.template'`; do
        envsubst '${NAMESERVER}' < "${template_file}" > "${template_file%.template}"
    done
    exec nginx -g 'daemon off;' $@
fi

exec $@
