# GITLAB BY DOCKER

## 參考資源

[https://docs.gitlab.com/omnibus/docker/](https://docs.gitlab.com/omnibus/docker/)

## 建mount目錄

```bash
mkdir  /home/docker/volumes/gitlab
```

如果有`selinux`的話要調整安全上下文，`docker instance`才有權限建檔。

```bash
chcon -Rt svirt_sandbox_file_t /home/docker/volumes/gitlab
```

## 執行gitlab instance

```bash
docker run -d --name gitlab \
--hostname "mydomain.dev.gitlab.com" \
--ulimit nofile=60000 \
--shm-size=1024m \
--restart=always \
-p 10443:443 -p 10080:80 -p 10022:22 \
-v /home/docker/volumes/gitlab/config:/etc/gitlab \
-v /home/docker/volumes/gitlab/logs:/var/log/gitlab \
-v /home/docker/volumes/gitlab/data:/var/opt/gitlab \
gitlab/gitlab-ce:latest
```

中文版

```bash
docker run -d --name gitlab \
--hostname "mydomain.dev.gitlab.com" \
--ulimit nofile=60000 \
--shm-size=1024m \
--restart=always \
-p 10443:443 -p 10080:80 -p 10022:22 \
-v /home/docker/volumes/gitlab/config:/etc/gitlab \
-v /home/docker/volumes/gitlab/logs:/var/log/gitlab \
-v /home/docker/volumes/gitlab/data:/var/opt/gitlab \
twang2218/gitlab-ce-zh:10.8.4
```

建立憑證，一步一步執行

```bash
openssl req \
       -newkey rsa:2048 -nodes -keyout mydomain.dev.com.key \
       -x509 -days 9999 -out mydomain.dev.com.crt

openssl x509 \
       -signkey mydomain.dev.com.key \
       -in mydomain.dev.com.csr \
       -req -days 9999 -out mydomain.dev.com.crt

openssl x509 \
       -in mydomain.dev.com.crt \
       -signkey mydomain.dev.com.key \
       -x509toreq -out mydomain.dev.com.csr
```

配置email寄送server

```bash
docker exec -it gitlab vi /etc/gitlab/gitlab.rb
```

修改以下内容

```rb
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.office365.com"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_user_name'] = "dev-auto@mydomain.com"
gitlab_rails['smtp_password'] = "mypassword"
gitlab_rails['smtp_domain'] = "mydomain.com"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_openssl_verify_mode'] = 'none'
gitlab_rails['smtp_tls'] = false
gitlab_rails['gitlab_email_from'] = 'dev-auto@mydomain.com'
```

reload後測試寄信

```bash
docker exec -it gitlab gitlab-ctl reconfigure
docker exec -it gitlab gitlab-rails console

Notify.test_email('my.mail@mydomain.com', 'Message Subject', 'Message Body').deliver_now
```

## 開啟頁面

`http://localhost:10080/`

預設管理員帳號`root`並修改密碼