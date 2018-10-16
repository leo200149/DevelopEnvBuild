# CI-RUNNER

## build image

第一次才需要`build docker image`，build完後可推至私庫。

[Dockerfile](Dockfile)

此`image` 基底為`maven:3.5-jdk-7-alpine`，內建`maven`及`jdk7`
可自行調整`jdk`版本，並額外加裝了

1. gitlab-runner
2. docker
3. gradle

### 執行build

執行完成後，打包出的`image`為`mydomain/gitlab-ci-runner-maven:alpine`

```bash
./build.sh
```

## 安裝 runner

### gitlab憑証

* `volumes/certs` 加入`gitlab server`的憑証檔。

### maven設定檔

* `volumes/m2` 加入自已的 `.m2` 設定檔 (`settings.xml`/`settings-security.xml`)

### 調整run/start-runner.sh

1. 調整`instance name`，預設為`my-runner`
2. 調整`gitlab server url`，預設為`http://mydomain.dev.gitlab.com/`
3. 加入需要的`hosts`

範例如下。

```bash
docker run -d --name my-runner \
--privileged=true \
--ulimit nofile=60000 \
--shm-size=1024m \
--restart=always \
--add-host "mydomain.dev.com:192.168.1.101" \
--add-host "mydomain.dev.gitlab.com:192.168.1.101" \
--add-host "mydomain.dev.nexus.com:192.168.1.101" \
-e CI_SERVER_URL=http://mydomain.dev.gitlab.com/ \
-e RUNNER_DESCRIPTION=my-runner \
-e RUNNER_EXECUTOR=shell \
-v volumes/certs:/etc/gitlab-runner/certs \
-v volumes/config:/etc/gitlab-runner \
-v volumes/ssh:/home/gitlab-runner/.ssh \
-v volumes/m2:/home/gitlab-runner/.m2 \
-v volumes/scripts:/home/gitlab-runner/scripts \
mydomain/gitlab-ci-runner-maven:alpine
```

### 啟動runner實例

切換到`run`目錄並執行`start-runner.sh`

```bash
./start-runner.sh
```

### runner 產生ssh key

```bash
docker exec -it -u gitlab-runner my-runner ssh-keygen
```

### 請 runner 加入 deploy 對象的 SSH 認證

為了能夠佈署到測試機，runner要能用ssh連線到測試機

```bash
docker exec -it -u gitlab-runner my-runner ssh-copy-id docker@192.168.1.111
```

### 請 runner 向 gitlab 註冊 runner

先到 `gitlab` 要掛 `runner` 的專案上找到 `token`
專案 > setting > CI/CD > Runners settings > Specific Runners > `your_project_token`

可使用`register-project.sh`如下

```bash
./register-project.sh "your_project_name" "your_project_token"
```

或是直接下`cmd`如下

```bash
docker exec -it my-runner \
    gitlab-runner register -n \
    --name "your_project_name/取什麼都可以" \
    -r "your_project_token"
```

### 在專案根目錄加入 .gitlab-ci.yml 並 push

參考 [gitlab_ci_example](gitlab_ci_yml_example\.gitlab-ci.yml)

### 檢查

1. `docker logs -f my-runner`檢查runner是否正常啟動。
2. 專案`push`後可在 專案 > CI/CD > Pipelines > All 看看有無開始自動編譯或佈署。