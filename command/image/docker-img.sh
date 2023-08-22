##########################################################################
# Docker Image Info
##########################################################################

# Docker Image 확인
$ docker images
$ docker image ls

# Docker Image 내부 구조(Dockerfile) 확인
$ docker history
$ docker history [IMAGE_NM]:[TAG_NM] --no-trunc > [HISTORY_FILE_NM].txt

# Docker Image 세부 정보 확인
$ docker image inspect

$ docker image inspect [IMAGE_NM]:[TAG_NM] --format="{{ .Os }}"
$ docker image inspect [IMAGE_NM]:[TAG_NM] --format="{{ .Config.ExposedPorts }}"
$ docker image inspect [IMAGE_NM]:[TAG_NM] --format="{{ .Os }} {{ .Config.ExposedPorts }}"

#! docker image inspect에 "Network" 정보는 없음.

##########################################################################
# Docker Registry Login
##########################################################################

# Docker Registry Login
$ docker login
> Username: [REGISTRY_ID]
> Password: [REGISTRY_PW]

# ------------------------------------------------------------

$ docker login --username ['REGISTRY_ID'] --password ['REGISTRY_PW'] [REGISTRY_ADDR]

# ------------------------------------------------------------

# Docker Hub Access Token Login
$ cat .docker_access_token | docker login -u [DOCKER_HUB_ID] --password-stdin

# ------------------------------------------------------------

# docker Login 정보 확인
$ docker info | grep -i username

# 비밀번호 확인 | base64 Encoding
$ cat /home/kevin/.docker/config.json

# Docker Registry Logout
$ docker logout

$ docker logout [REGISTRY_ADDR]

##########################################################################
# Docker Image Lifecycle
##########################################################################

# Docker Image 검색 (저장소)
$ docker search

# Docker Image Pull
$ docker pull

$ docker image pull nginx:1.21-alpine
$ docker pull [REGISTRY_ADDR]/[IMG_NM]:[TAG_NM]

# docker tag : 도커 이미지에 태그 설정
$ docker tag

# Docker Image Push
$ docker push [USER_ID]/[IMG_NM]:[TAG_NM]

# Dockerfile으로 구성된 도커 이미지 생성
$ docker build

# Docker Image 삭제
$ docker rmi
$ docker image rm

$ docker rmi -f $(docker images -q)

##########################################################################
# Docker Image Backup
##########################################################################

# Docker Image 저장 (백업) & 로드 (복구)
$ docker save
$ docker load
