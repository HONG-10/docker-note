# Docker Day 1
## Docker Intro

### Docker Training Goal
1. Dockerfile -> contaienr infa 생성 <-> linux 기반의 명령어
2. docker compose -> *.yaml 정의(선언형) -> contaienr service 배포 -> docker CLI

> linux -> docker -> kubernetes -> CI/CD -> Cloud

### LXC (LinuX Continaer)

* Process 격리 기술
* Linux Kernel에 포함된 기술
* 독립된 인프라 환경 구성

#### chroot (Change Root) | Process 격리
* 독립된 Host (Container) --> rootFS (/) --> PID=1
  원래 Host PID=1 --> init --> systemd / 독립된 Host(Container) PID는 Process 일뿐 (init X)
* 자체 방화벽 --> iptables --> all deny

#### namespace
* PID, mount, network, ...
* 서비스를 위한 networking | IP, MAC, iptable, route table, IPC

#### cgroup (Control Group) | 자원 할당 제어
* Spec Control | CPU, Memory, Disk, (+Network)
* Container = 독립된 인프라 -> cgroup을 통해 HostOs에서 자원을 배정 받음. (Resource Limit을 주지 않으면 무제한으로 사용)

### Image vs Container

> 필요한 OS, S/W, 환경설정 등을 하나로 Packaging --> Image = Infra

> Container = Process

* Image | 정적 | Read Only
* Container | 동적 | Read/Write

> Image(Infra) 로 원하는 Container Service (Application) 구현
> Image --> docker run -> Container화 (Containerization)
> 1:N (Image:Container)

### Image

* VM      | .vdi (Virtual Disk Image) --> OVF Packaging
* Docker  | image                     --> OCI Packaging

### Image 생성 방법

1. Dockerfile | docker build
> Dockerfile Image 생성 (Base Image + Layer)

2. Container | docker commit

> docker image는 layer(계층) 구조로 이루어짐.
  -> docker pull debian:10 -> hub.docker.com로부터 download
  -> /var/lib/docker에 저장 <- 개별 레이어 download 후 merge(병합)

### Container

1. Process | /var/lib/docker
2. Image Snapshot | /var/lib/docker/overlay2 | 복제본

> Container는 가벼워야 한다! (MSA, 경량화, alpine & slim)

> Container : image snapshot -> process -> container
docker create   | image snapshot create
docker start    | process start
-----------------------------------------------------
docker run = [pull] + create + start + [command]
-----------------------------------------------------
docker stop     | process stop
docker rm       | image snapshot rm

### Application Container
1. Database | MySQL, Mariadb, Oracle, MS-SQL, redis, postgreSQL, ...

2. Proxy | Nginx, Apache, HAproxy, ...
  - Nginx: Reverse Proxy --> /etc/nginx/nginx.conf (web server --> proxy)


### Docker Management Tip!

* TZ -> 시간 동기화 -> container는 기본적으로 host와 시간동기화 되지 않는다! -> NTP

* linux -> fuse(filesystem userspace) -> 특정 dir -> mount -> daemon화 <--- chroot지원
	  stage area -> ETL -> 전송 속도 6G/b

* alpine linux | apk
* CentOS(Community ENTerprise linux Operating System) | yum

* Port Mapping 된 애들 죽이는 법
> sudo iptables -t nat -L -n

* sar | System Activity Report

* MSA --> CI & CD & CT (Continuous Test) & CM (Continuous Monitoring)

* CKS | image 취약성 점검 (vernervility) -> scanner -> Trivy

* port range -> 1~1024(관리용), 그 외~65536

* Image Tag는 경량 우선, 그러나 app 특성에 맞게

* Container 가상화의 실체 (image를 container로 실행하면?)
	1. process
	2. image snapshot

