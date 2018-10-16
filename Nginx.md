# Nginx BY DOCKER

## 參考資源

[https://hub.docker.com/_/nginx/](https://hub.docker.com/_/nginx/)

## 建mount目錄

```bash
mkdir /home/docker/volumes/nginx
```

如果有`selinux`的話要調整安全上下文，`docker instance`才有權限建檔。

```bash
chcon -Rt svirt_sandbox_file_t /home/docker/volumes/nginx
```

## Nginx instance

### 初始conf

先起一個暫時的instance，copy一份config出來才能mount

```bash
docker run -d --name nginx-tmp nginx

docker cp nginx-tmp:/etc/nginx/ /home/docker/volumes/nginx

docker rm -f nginx-tmp
```

### 啟動Nginx

```bash
docker run -d --name nginx \
-p 80:80 -p 443:443 -p 8084:8084 -p 8082:8082\
--ulimit nofile=60000 \
--restart=always \
-v /home/docker/volumes/nginx:/etc/nginx \
nginx
```

## 設定conf

`nginx.conf`內`IP`位置需調整

[nginx.conf](nginx/nginx.conf)
[server/gitlab.conf](nginx/server/gitlab.conf)
[server/nexus.conf](nginx/server/nexus.conf)
[server/nexus-docker.conf](nginx/server/nexus-docker.conf)
[server/redmine.conf](nginx/server/redmine.conf)

設定好後重新`reload nginx`或重啟`instance`

```bash
docker exec -it nginx service nginx restart
```
