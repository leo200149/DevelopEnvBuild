# NEXUS3 BY DOCKER

## 參考資源

[https://hub.docker.com/r/sonatype/nexus3/](https://hub.docker.com/r/sonatype/nexus3/)

## 建mount目錄

```bash
mkdir /home/docker/volumes/nexus
chown -R 200 /home/docker/volumes/nexus
```

如果有`selinux`的話要調整安全上下文，`docker instance`才有權限建檔。

```bash
chcon -Rt svirt_sandbox_file_t /home/docker/volumes/nexus
```

## 執行Nexus instance

```bash
docker run -d --name nexus \
--ulimit nofile=60000 \
--shm-size=1024m \
--restart=always \
-p 10081:8081 \
-p 10050:10050 \
 -v /home/docker/volumes/nexus:/nexus-data sonatype/nexus3
```

## 開啟頁面

`http://localhost:10081/`

預設管理員帳號`admin/admin123`並修改密碼