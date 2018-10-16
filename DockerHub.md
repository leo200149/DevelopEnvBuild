# Docker私庫

```sh
docker run -d --name registry \
-p 5000:5000 \
-v /home/docker/volumes/docker-registry:/var/lib/registry \
registry
```