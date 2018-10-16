# REDMINE BY DOCKER

## 參考資源

[https://hub.docker.com/r/sameersbn/redmine/](https://hub.docker.com/r/sameersbn/redmine/)

## 服務介紹

專案管理軟體。

## 建mount目錄

```bash
mkdir /home/docker/volumes/redmine
chown -R 200 /home/docker/volumes/redmine
```

如果有`selinux`的話要調整安全上下文，`docker instance`才有權限建檔。

```bash
chcon -Rt svirt_sandbox_file_t /home/docker/volumes/redmine
```

## 執行Redmine instance

此`Redmine image`與`db`為互相獨立的instance，並用`docker link`連接起來，可選用`postgresql`或`mysql`，這裡使用`mysql`做為存檔資料庫。

### 建立mysql instance

```bash
docker run -d --name=redmine-mysql \
--ulimit nofile=60000 \
--shm-size=1024m \
--restart=always \
-e DB_NAME=redmine \
-e DB_USER=redmine \
-e DB_PASS=redmine@2018 \
-v /home/docker/volumes/redmine/mysql:/var/lib/mysql \
sameersbn/mysql:latest
```

### 建立redmine instance

```bash
docker run -d --name=redmine \
--ulimit nofile=60000 \
--shm-size=1024m \
--restart=always \
--link redmine-mysql:mysql \
-p 3000:80 \
-e DB_NAME=redmine \
-e DB_USER=redmine \
-e DB_PASS=redmine@2018 \
-v /home/docker/volumes/redmine/redmine:/home/redmine/data \
sameersbn/redmine:latest
```

## 開啟頁面

`http://localhost:3000/`

預設管理員帳號`admin/admin123`並修改密碼