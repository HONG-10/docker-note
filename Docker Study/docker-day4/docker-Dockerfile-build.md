# Docker Day 4
## Dockerfile

### Dockerfile Build 이해
	
FROM [IMAGE_NM] # -> container (Read/Write) -> image -> rm container
+ COMMADN       # -> container (Read/Write) -> image -> rm container 
+ COMMADN       # -> container (Read/Write) -> image -> rm container
...
+ COMMAND       # -> container (Read/Write) -> image (최종) -> rm container

### Dockerfile 작성법
#### Single Stage

CMD         | image build 시 저장만, container로 생성되면 실행될 프로세스
		    | Dockerfile에 1개 만 사용 가능 (맨 마지막 CMD가 실행)
		    | 데몬 실행, application 실행파일

ENTRYPOINT	| image build 시 저장만, container로 생성되면 실행될 프로세스
		    | 인수처리 | 프로세스 동작 시 사용되는 인수 $ docker run [ENTRYPOINT_VALUE]
            | Dockerfile에 여러개 작성 및 실행 가능
----------------------------------------------------------------
ADD         | URL 작성 가능 >>> http://test/abc/test.txt(URL) 내부경로/파일명
            | 자동 압축 해제 >>> source.tar.gz /내부경로

COPY        | ㅇㄹㄷ
            | 
----------------------------------------------------------------
USER kevin  | container 내부 기본 사용자는 root -> 위협요소 -> 사용자 추가
            | image에 사용자 kevin 자동 생성 -> docker run -u kevin

WORKDIR	    | /test 1) cd /test		2) docker exec .. bash -> /test
			| Application Source 경로 (작업경로) /data/diplwapl

```Dockerfile
FROM ubuntu:18.04
RUN apt-get update && apt-get install -y -q nginx
COPY index.html /var/www/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
```bash
docker images | grep myweb
docker image history myweb:4.0
docker run -itd --name=webserver4 -p 8004:80 myweb:4.0
```

#### Multi Stage Build

> 상황 : scratch 에서 실행할 실행 파일을 Go언어에서 생성하여 사용한다.

```Dockerfile
FROM golang:1.15-alpine3.12 AS gobuilder-stage
MAINTAINER "Hong 10 | iyhong@cslee.co.kr"
LABEL "purpose"="Service Dev using Multi-stage builds"
WORKDIR /usr/src/goapp
COPY gostart.go .
#   CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ["/test/go실행 파일 생성"]
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /usr/local/bin/gostart

FROM scratch AS runtime-stage
#    --from=gobuilder-stage  ["/test/go실행 파일 생성"]  ["현재 scratch의 경로/파일명"]
COPY --from=gobuilder-stage /usr/local/bin/gostart /usr/local/bin/gostart
CMD ["/usr/local/bin/gostart"]

# FROM gobuilder-stage에서 생성된 파일을 FROM runtime-stage에서 사용 가능
# gobuilder-stage는 작업 완료 후 제거
# 최종 이미지에는 마지막 Stage(runtime-stage)만 Layer로 들어감
# 확인 --> docker image history & docker image inspect
# 결론 --> image 경량화 + build 속도 향상 -> container 성능(속도) 향상

# FROM golang
# RUN apt scratch install
```

### Dockerfile Command

```bash
# . (현재 경로)에 있을 시
$ vi Dockerfile
$ docker build -t [IMAGE_NM]:[TAG_NM] .

# 다른 파일명 & 다른 경로에 있을 시
$ vi Dockerfile_Nginx
$ docker build -f Dockerfile_Nginx -t [IMAGE_NM]:[TAG_NM] .
```

### Dockerfile Best Practices

* Container -> 경량화 : Layer를 최소화하는 법 권장

* Dockerfile Line = Image Layer

> CASE.1 ***
```Dockerfile
RUN apt-get -y update
RUN apt-get -y install python3-software-properties \
    software-properties-common \
    bzip2 \
    ssh
```
> CASE.2
```Dockerfile
RUN apt-get -y update && apt-get -y install python3-software-properties 
    software-properties-common bzip2 ssh
```

> CASE.3 비 권장! -> 레이어가 증가
```Dockerfile
RUN apt-get -y update
RUN apt-get -y install python3-software-properties 
RUN apt-get -y install software-properties-common 
RUN apt-get -y install bzip2 
RUN apt-get -y install ssh
```

> CASE.A
```Dockerfile
FROM ubuntu:14.04
MAINTAINER "Hong 10 | iyhong@cslee.co.kr"
LABEL "purpose"="webserver practice"
RUN apt-get update && apt-get install -y apache2
WORKDIR /var/www/html
ADD index.html .
EXPOSE 80
CMD apachectl -D FOREGROUND
```

> CASE.B ***
```Dockerfile
FROM ubuntu:14.04
MAINTAINER "Hong 10 | iyhong@cslee.co.kr"
LABEL "purpose"="webserver practice"
RUN apt-get update && apt-get install -y apache2 && \
    apt-get clean -y && apt-get autoremove -y && \
    rm -rfv /tmp/* /var/lib/apt/lists/* /var/tmp/*
WORKDIR /var/www/html
ADD index.html .
EXPOSE 80
CMD apachectl -D FOREGROUND
```

> CASE.C ***
```Dockerfile
FROM alpine
MAINTAINER "Hong 10 | iyhong@cslee.co.kr"
LABEL "purpose"="webserver practice"
RUN apk update && apk install -y apache2
WORKDIR /var/www/html
ADD index.html .
EXPOSE 80
CMD apachectl -D FOREGROUND
```

> CASE.D
```Dockerfile
FROM ubuntu:14.04
MAINTAINER "Hong 10 | iyhong@cslee.co.kr"
LABEL "purpose"="webserver practice"
RUN apt-get update && apt-get install -y apache2 vim curl
ADD webapp.tar.gz /var/www/html
WORKDIR /var/www/html
EXPOSE 80
CMD /usr/sbin/apache2ctl -D FOREGROUND
```

> Best CASE | alpine, slim 사용, 설치 파일 등 불필요한 파일 삭제 
```Dockerfile
# image 내부에 설치 파일이 남는다.
RUN apt-get update && apt-get install -y -q nginx (X)
RUN apt-get update && apt-get install -y -q nginx:1.23.1-alpine (X)

# 설치 파일 제거
sudo apt-get clean -y && \
sudo rm -rf /var/lib/apt/lists/*
```
