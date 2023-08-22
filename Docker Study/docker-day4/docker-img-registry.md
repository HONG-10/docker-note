# Docker Day 4
## Docker Image Managed

Step. 1 Docker Registry Login - 로그인| docker login
Step. 2 Docker Image Tagging - 주소 지정 | docker image tag [IMAGE_NM]:[TAG_NM] [USER_ID]/[IMAGE_NM]:[TAG_NM]
Step. 3 Docker Registry Push - Image 등록 | docker image push [IMAGE_NM]:[TAG_NM] [USER_ID]/[IMAGE_NM]:[TAG_NM]
Step. 4 Docker Registry Logout - 로그아웃 | docker logout

## Docker Image Registry 
### Public Registry - Docker Hub

> https://hub.docker.com/

* Registry 로그인 | docker image login
  1. Password
    - 비밀번호 확인 | `$ cat /home/kevin/.docker/config.json`
    - 현재 User 확인 | `$ docker info | grep -i username`

  2. Docker Hub Access Token
    - step. 1 Docker Hub Account Setting
    - step. 2 Security -> new access token : rwd
    - step. 3 access token 서버에 저장 후 로그인 활용
    - step. 4 active 기능 활용

  3. 추후 제공

### Private Registry 1 - Docker Registry

> curl & webui 확인

* registry server (hostos1)
 Insecure Registries:
  192.168.56.101:5000
  127.0.0.0/8

* registry client (hostos2)
 Insecure Registries:
  192.168.56.101:5000
  127.0.0.0/8

```bash
docker pull 192.168.56.101:5000/httpd:2.4
```

### Private Registry 2 - Nexus

* Nexus Setting

> sudo vi /etc/init.d/docker

```config
...
DOCKER_OPTS=--insecure-registry 192.168.56.101:[NEXUS_PORT]
...
```

> sudo vi /etc/docker/daemon.json
```json
{
  "insecure-registries": ["192.168.56.101:[NEXUS_PORT]"]
}
```

### Private Registry 3 - GCR (Google Container Registry)
