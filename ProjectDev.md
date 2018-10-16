# 專案DEV環境

## 參考資源

[https://hub.docker.com/_/mysql/](https://hub.docker.com/_/mysql/)

## Mysql by docker

### 建mount目錄

```bash
mkdir  /home/docker/volumes/my-mysql
```

如果有`selinux`的話要調整安全上下文，`docker instance`才有權限建檔。

```bash
chcon -Rt svirt_sandbox_file_t /home/docker/volumes/my-mysql
```

### 執行mysql instance

```bash
docker run -d --name=my-mysql \
--ulimit nofile=60000 \
--shm-size=1024m \
--restart=always \
-p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=my@2018 \
-v /home/docker/volumes/my-mysql/conf:/etc/mysql/conf.d \
-v /home/docker/volumes/my-mysql/data:/var/lib/mysql \
mysql:5.6.40
```

### 連線資訊

1. 連線資訊:`localhost:3306`
2. 預設管理員帳號:`root\my@2018`

---