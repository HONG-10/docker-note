# Docker Day 1
## Docker Command 1

### OS - ubuntu

> Image는 Layer 구조로 되어 있음을 이해한다.
> Image를 Pull 받을 때는 미리 설정한 Repository로 부터 Pull 받는 것을 이해한다.

```bash
$ docker pull ubuntu:16.04
> 16.04: Pulling from library/ubuntu  # docker.io 사이트로부터 해당 image download
> 
> 58690f9b18fc: Pull complete		  # layer
> b51569e7c507: Pull complete		  # layer
> da8ef40b9eca: Pull complete		  # layer
> fb15d46c38dc: Pull complete		  # layer
> 
> Digest: sha256:1f1a2d56de1d604801a9671f301190704c25d604a416f59e03c04f5c6ffee0d6 # layer merge
> Status: Downloaded newer image for ubuntu:16.04
> docker.io/library/ubuntu:16.04	  # /var/lib/docker

$ docker images

$ docker run -it ubuntu:18.04 echo 'hello docker~'
> hello docker~ 		# from container
```

> Container는 경량화되어야 하기 때문에 패지키 설치는 지양해야 함을 이해한다.
> Container 내부에서 통신이 되는 것을 이해한다. (Ping = Packet Internet Groper)

```bash
$ docker run -it ubuntu:18.04 bash
 @ cat /etc/lsb-release
 @ ifconfig
 > bash: ifconfig: command not found
 @ apt update -y
 @ apt install -y net-tools iputils-ping
 @ ifconfig
 > eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
 > inet 172.17.0.2  netmask 255.255.0.0  broadcast 172.17.255.255
 > ...
 @ ping 192.168.56.1 	# Windows
 @ ping 8.8.8.8		 	# Google DNS
```

### OS - CentOS

> Container PID=1은 init Process가 아님을 이해한다.
> 이는 HostOS - Container 간 연결과 LXC의 chroot 기술임을 이해한다.

> Container 내부 첫 exit 시 정상종료 (Graceful Shutdown)가 되어 Container 상태가 Exited (0)가 된다.
> Container 외부로 나올 때는 Ctrl+p Ctrl+q 로 나온다. (read escape sequence)

```bash
$ docker pull centos:7
$ docker run -it centos:7 bash
 @ ps -ef
 > UID          PID    PPID  C STIME TTY          TIME CMD
 > root           1       0  0 06:28 pts/0    00:00:00 bash	
 @ exit
$ docker ps -a
$ docker restart serene_blackburn
$ docker exec -it serene_blackburn bash
 @ read escape sequence 	# Ctrl+p Ctrl+q
```

### DB - MySQL

> docker hub에서 필수 입력 변수 등 docker run 시 필요한 사항을 확인해야 한다.

```bash
$ docker pull mysql:5.7-debian
$ docker images
$ docker run -itd --name=mydb \
    -e MYSQL_ROOT_PASSWORD=패스워드 \
    -e MYSQL_DATABASE=item \
    mysql:5.7-debian

$ docker ps
$ docker exec -it mydb bash
 @ cat /etc/os-release
 > PRETTY_NAME="Debian GNU/Linux 10 (buster)"
 > NAME="Debian GNU/Linux"
 @ /etc/init.d/mysql start
 > [info] A MySQL Server is already started.
 @ mysql -uroot -p
  ^ show databases;
```

### DB - MariaDB


```bash
$ docker run -d --name mariadb \
    -e MYSQL_ROOT_PASSWORD=mkevin \
    -e MARIADB_DATABASE=item \
    -p 3306:3306 \
    mariadb:10.2
				
$ sudo netstat -nlp | grep 3306
> tcp    0      0 0.0.0.0:3306            0.0.0.0:*           LISTEN      7418/docker-proxy

$ ps -ef | grep 7418
root        7418    1158  0 16:43 ?        00:00:00 /usr/bin/docker-proxy -proto tcp -host-ip 0.0.0.0 -host-port 3306 -container-ip 172.17.0.5 -container-port 3306

# Endpoint ---> 0.0.0.0 -> 192.168.56.101:22 -> 3006(docker-proxy) -> 172.17.0.5:3306

 @ apt update
 @ apt install -y git
 @ git clone https://github.com/brayanlee/emp_db.git
 @ mysql -uroot -p
  ^ create database employees;
  ^ use employees;
  ^ source employees.sql
```


### Monitoring - cAdvisor

> Container Monitoring(Observability) 주체

Metric | cpu, memory, disk, network usage(utilization:활용률)
Log | Observability (관측가능성)

* Prometheus & Grafana (open source)
* Elasticsearch & Logstash & Kibana
* Elasticsearch & Flunted & Kibana
* Cadvisor(Container Advisor) | google에서 open source로 image 제공

```bash
$ docker run \
>   --volume=/:/rootfs:ro \
>   --volume=/var/run:/var/run:rw \
>   --volume=/sys:/sys:ro \
>   --volume=/var/lib/docker/:/var/lib/docker:ro \
>   --publish=9559:8080 \
>   --detach=true \
>   --name=cadvisor \
>   google/cadvisor:latest

$ docker ps | grep cadvisor
$ sudo netstat -nlp | grep 9559
$ ps -ef | grep 8437
```
