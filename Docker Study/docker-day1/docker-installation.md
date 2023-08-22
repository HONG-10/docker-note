# Docker Installation

## Docker Edition
* EE (enterprise edition) | 상용
* CE (communite edition) | open source
	- stable | 안정화 버전 ***
	- edge | beta 버전

## Docker Installation

	-> 해당 사이트(https)에서 제공하는 key를 통해 원하는 패키지 설치
	-> curl https://download.docker.com ~~
	-> GPG(Gnu Package Guard)
	-> apt, yum -> repository 개념을 사용 -> https://download.docker.com 등록
    
### OS 권장 기준 확인

> 64bit OS & 
> kernel version 3.1 이상

```bash
hostname

uname -ar
> Linux hostos1 5.15.0-67-generic #74~20.04.1-Ubuntu SMP Wed Feb 22 14:52:34 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
```

### Disk 권장 사항 확인

> docker 전용 Disk 생성 --> xfs Filesystem 으로 /var/lib/docker에 mount

### Docker Engine 설치

```bash
sudo apt-get update -y

# 필수 패키지 설치
sudo apt-get install -y --no-install-recommends \
    net-tools openssh-server vim htop tree curl \
	iptraf-ng iputils-ping dnsutils # dnsutils | dig = Domain Information Groper & iputils-ping | ping = packet internet groper

# Networking Test
ifconfig                # IP 확인
ping 192.168.56.1       # windows 확인
ping 8.8.8.8            # 외부 연결 확인

# 의존 패키지 install
sudo apt-get install -y --no-install-recommends \
    apt-transport-https ca-certificates software-properties-common

# apt-key 등록
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# apt-key 등록 확인
sudo apt-key fingerprint

# apt-repository 추가
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# apt-repository 추가 확인
tail /etc/apt/sources.list

# docker-ce 설치
sudo apt-get update -y
sudo apt-cache policy docker-ce     # Candidate 확인
sudo apt-get install -y docker-ce 

# docker-ce 설치 확인
sudo docker version
sudo ls -al /var/lib/docker     # > docker는 root 권한으로 설치됨.
sudo ls -l /var/run/docker.sock # > docker는 소켓 통신으로 돌아감.

# 사용할 User docker Group 등록 (docker command sudo 없이 사용)
sudo usermod -aG docker kevin

# docker systemd 등록
sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl restart docker
sudo systemctl status docker

sudo reboot

# ===========================

# sudo 없이 사용 확인
docker version

# docker 정보 확인
docker info

```

### hosts 등록
```bash
sudo vim /etc/hosts
```
```config
127.0.0.1       localhost
127.0.1.1       hostos1
192.168.56.101  hostos1
192.168.56.102  hostos2
```

### Network 확인
```bash
sudo netstat -nlp | grep 22
> 0.0.0.0:22

route
> 172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
# 255.255.0.0 -> CIDR -> 172.17.0.0/16 -> 65536 개
```

### Server Shutdown 후 복제 작업 진행

> hostos1
```bash
$ sudo shutdown -h now
```
> hostos2

* hostos2 booting! -> kevin/패스워드 -> linux 제어판에서 network(enp0s8) -> 192.168.56.102

```bash
$ sudo hostnamectl set-hostname hostos2
$ ifconfig
$ hostname
$ sudo vi /etc/hosts # 2 라인의 hostos1을 hostos2로 변경
$ sudo reboot
```

## Docker Shell Script Installation
```bash
# docker 에서 제공하는 shell script을 이용한 자동 설치
curl -fsSL https://get.docker.com -o get-docker.sh
sudo vi get-docker.sh           # shell script 내용 확인 후 변경 가능
chmod +x get-docker.sh          # 실행 권한 부여
sudo sh get-docker.sh           # 설치
```