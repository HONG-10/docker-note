# Docker Day 4
## Docker Volume

* docker volume
* docker run -v | --volume

> NFS 기능(share)과 같음
> Data 지속성(영속성)

### Bind Mount

* 컨테이너 내부에서 df -ha로 확인 가능 (Mount 되어 있음.)
    * -v [HOST_PATH]:[CONTAINER_PATH]
    * 양쪽 경로가 없으면 자동으로 생성 (단, root 소유로 생성됨.)

1. xfs | Volume Quota

```bash
$ sudo mount | grep xfs
> /dev/sda1 on / type xfs (rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota)
> /dev/sdb1 on /var/lib/docker type xfs (rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,prjquota)
# > /dev/sdb1 on /var/lib/docker type xfs (rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquot) ???
```

2. FS | pquota (Project Quota)

```bash
sudo vim /etc/fstab
# 추가
# UUID=78167fc6-b87f-4011-ba56-e46c41513adb /var/lib/docker xfs     defaults,pquota        0       0

sudo vim /etc/default/grub
# 추가
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash rootflags=uquota,pquota"

sudo reboot
```

3. --storage-opt

```bash
$ docker run -it --name=myos \
    -v /home/kevin/webapp:/webapp \
    ubuntu:14.04 bash
 @ df -h
 > Filesystem      Size  Used Avail Use% Mounted on
 > overlay         100G  6.3G   94G   7% /			    # = HostOS:/var/lib/docker
 > tmpfs            64M     0   64M   0% /dev
 > tmpfs           2.0G     0  2.0G   0% /sys/fs/cgroup
 > shm              64M     0   64M   0% /dev/shm
 > /dev/sda1        66G  8.8G   57G  14% /webapp        # = HostOS:/
 > /dev/sdb1       100G  6.3G   94G   7% /etc/hosts
 > tmpfs           2.0G     0  2.0G   0% /proc/acpi
 > tmpfs           2.0G     0  2.0G   0% /proc/scsi
 > tmpfs           2.0G     0  2.0G   0% /sys/firmware
```

```bash
$ docker run -it --name=myos \
    -v /home/kevin/webapp:/webapp \
    --storage-opt size=1G \
    ubuntu:14.04 bash
> docker: Error response from daemon: --storage-opt is supported only for overlay over xfs with 'pquota' mount option.

$ docker run -it --name=myos \
    -v /home/kevin/webapp:/webapp \
    --storage-opt size=1G \
    ubuntu:14.04 bash
 @ df -h
 > Filesystem      Size  Used Avail Use% Mounted on
 > overlay         1.0G  8.0K  1.0G   1% /
```

### docker volume create

* docker volume create [VOLUME_NM]
    * -v [VOLUME_NM]:[CONTAINER_PATH]
* Default 경로 | /var/lib/docker/volumes

### tmpfs mount

* 임시 메모리 공간에 대한 공유 설정 --> 휘발성
    * --tmpfs /run:rw,noexec,nosuid,size=65536k

## Docker Volume 활용

### DB Backup, Migration

```bash
$ docker run -itd --name=mysql-volume \
    -e MYSQL_ROOT_PASSWORD=mkevin \
    -e MYSQL_DATABASE=dockertest \
    -v /home/kevin/volume_test:/var/lib/mysql \
    mysql:5.7-debian

$ docker exec -it mysql-volume bash
 @ mysql -uroot -p
  > use dockertest;
  > create table mytab (c1 int, c2 char);
  > insert into mytab values (1,'a');
  > select * from mytab;
  > exit
 @ cd /var/lib/mysql
 @ cd dockertest/
 @ ls -l

$ docker stop mysql-volume && docker rm mysql-volume

$ docker run -itd --name=mysql-volume \
    -e MYSQL_ROOT_PASSWORD=mkevin \
    -e MYSQL_DATABASE=dockertest \
    -v /home/kevin/volume_test:/var/lib/mysql \
    mysql:5.7-debian

$ docker exec -it mysql-volume bash
 @ mysql -uroot -p
  > use dockertest;
  > show tables;
  > select * from mytab;
```

> mysql:5.7-debian to mysql:8.0 (O)
> mysql:8.0 to mariadb:10.3 (X)
> 서로 다른 Image Layer이기 때문

### HostOS - Container NTP 동기화

> 상황 : python 정기적인 크롤링 (30분 마다) -> 테스트 성공 -> 컨테이너 내부에서 수행하면 오류

```bash
$ date
> 2023. 03. 23. (목) 10:23:35 KST

$ docker run --rm \
    ubuntu:14.04 date
> Thu Mar 23 01:24:02 UTC 2023

$ docker run --rm \
    -v /etc/localtime:/etc/localtime \
    ubuntu:14.04 date
> Thu Mar 23 10:25:16 KST 2023
```

### HostOS - Container History 동기화

> 상황 Container의 History를 HostOS에서 확인하려고 함.

```bash
$ docker run -it --rm \
    -v /home/kevin/.bash_history:/root/.bash_history \
    centos:7 bash

 @ ls
 @ touch file1
 @ echo 'docker world' > file2
 @ df -h
 > ...
 > /dev/sda1        66G  8.8G   57G  14% /root/.bash_history
 @ exit

$ cat .bash_history
> ...
> ls
> touch file1
> echo 'docker world' > file2
> df -h
> exit
```

### Web Server Log

> Web Server | Access Log 중요 ---> HostOS-Container Mount 활용

```bash
$ mkdir nginx-log
$ docker run -d --name=nginx-volume \
    -v /home/kevin/nginx-log:/var/log/nginx \
    -p 8001:80 \
    nginx:1.23.3

$ cd nginx-log/
$ ls -al
$ tail -f access.log

# Nginx Log 패턴 10개
# $1 $2 $3 $4 ~ $10 -> shellscript -> awk

$ awk '$4>"[23/Mar/2023:01:07:18]" && $4<"[23/Mar/2023:01:08:03]"' access.log | awk '{ print $1 }' | sort | uniq -c | sort -r | more
>     8 192.168.56.102
>    18 192.168.56.1
```

> Docker Volume | File Mount OK
