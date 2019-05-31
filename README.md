# Quick Start

```shell
$ docker run -d --name supercache-proxy -p 3128:3128 jmaroeder/supercache-proxy:latest
```

Set your web browser's proxy to use `localhost:3128`.

You may want to disable certificate checking.

You can confirm the proxy is working by using cURL:

```shell
$ curl -X GET https://httpbin.org/delay/3 --proxy localhost:3128 --insecure
# this first request should take 3 seconds to complete
$ curl -X GET https://httpbin.org/delay/3 --proxy localhost:3128 --insecure
# this second request should complete instantaneously, as the result will be in the cache
```


# Notes

Based heavily on [funes](https://github.com/mirainc/funes) by [mirainc](https://github.com/mirainc).
