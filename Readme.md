# 用DOCKER搭設CI環境

在`/etc/hosts`檔中加入 `ip`自行修改

```bash
192.168.1.111 mydomain.dev.com
192.168.1.111 mydomain.dev.gitlab.com
192.168.1.111 mydomain.dev.nexus.com
192.168.1.111 mydomain.dev.redmine.com
192.168.1.111 mydocker.com
```

目前使用`docker`建立服務如下

## Nginx

1. [說明文件](Nginx.md)

---

## Gitlab

1. [http://mydomain.dev.gitlab.com](http://mydomain.dev.gitlab.com)
2. [說明文件](Gitlab.md)
3. [CI RUNNER](ci-runner)

---

## Nexus

1. [http://mydomain.dev.nexus.com](http://mydomain.dev.nexus.com)
2. [說明文件](Nexus.md)

---

## Redmine

1. [http://mydomain.dev.redmine.com](http://mydomain.dev.redmine.com)
2. [說明文件](Redmine.md)
