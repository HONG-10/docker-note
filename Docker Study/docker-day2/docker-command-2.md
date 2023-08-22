# Docker Day 2
## Docker Command 2

### App - Nginx

> Nginx

* c 언어 기반 App
* Web Server | 80
* Reverse Proxy (Load Balancer) 
* Ingress Controller | with K8s
* API Gateway | MSA 트래픽 처리를 위한 Micro Gateway

- Command
```bash
docker pull nginx:1.23.3-alpine
docker images | grep nginx
docker image history nginx:1.23.3-alpine
docker run -d -p 8001:80 --name=webserver1 nginx:1.23.3-alpine
docker ps | grep webserver
sudo netstat -nlp | grep 8001
ps -ef | grep 11979
curl localhost:8001

vi index.html
docker cp index.html webserver1:/usr/share/nginx/html/index.html
docker cp docker_logo.png webserver1:/usr/share/nginx/html/docker_logo.png
vi index2.html
docker cp index2.html webserver1:/usr/share/nginx/html/index.html
```

> vi Dockerfile

```Dockerfile
FROM nginx:1.23.3-alpine
COPY index2.html /usr/share/nginx/html/index.html
COPY docker_logo.png /usr/share/nginx/html/docker_logo.png
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
```bash
docker build -t myweb:1.0 .
docker images | grep myweb
docker run -d --name=webserver2 -p 8002:80 myweb:1.0
vi index2.html
docker cp index2.html webserver2:/usr/share/nginx/html/index.html
```

> vi Dockerfile

```Dockerfile
FROM nginx:1.23.3-alpine
RUN mkdir -p /usr/share/nginx/html/assets
RUN mkdir -p /usr/share/nginx/html/css
RUN mkdir -p /usr/share/nginx/html/js
COPY index.html /usr/share/nginx/html/index.html
COPY assets /usr/share/nginx/html/assets
COPY css /usr/share/nginx/html/css
COPY js /usr/share/nginx/html/js
EXPOSE 80
# image가 컨테이너 내부에서 실행될 때 nginx 데몬을 백그라운드로 실행
CMD ["nginx", "-g", "daemon off;"] 
```
```bash
docker build -t myweb:2.0 .
docker images | grep myweb
docker run -d --name=webserver3 -p 8003:80 myweb:2.0
curl localhost:8003
```

### Env - Python-MySQL API 통신 (or Network 통신)

> Python

* Programming
* Web Application Server | Django, Flask, FastAPI, ...
* Big Data
* AI / ML / DL


```bash
docker run -d --name=starbucks -p 13306:3306 -e MYSQL_ROOT_PASSWORD=패스워드 -e MYSQL_DATABASE=coffee mysql:5.7-debian
docker ps | grep star
docker inspect starbucks | grep -i ipa  172.17.0.4
vi startbucks_table.sql
docker cp startbucks_table.sql starbucks:/startbucks_table.sql
docker exec -it starbucks bash
 @ mysql -uroot -p
  > show databases;
  > use coffee;
  > source startbucks_table.sql
  > show tables;
  > select * from users;
  > insert into users values (3,'kevin','kevin@dshub.cloud','패스워드','admin');
  > select * from users;
```
```bash
docker pull python:3.10-slim
docker pull python
docker images | grep python # 차이 확인

vi py-starbucks.py
docker cp py-starbucks.py py-test:/py-starbucks.py
docker exec -it py-test pip install pymysql
docker exec -it py-test python3 /py-starbucks.py
```

### Env - Python-Redis (or Memcache)

```bash
docker run -itd --name=redis-db -p 6379:6379 redis:7 redis-server --requirepass 패스워드 --port 6379
docker ps | grep redis
docker exec -it redis-db redis-cli -a 패스워드
vi redis-app.py
```

> vi Dockerfile

```Dockerfile
FROM python:3.10-slim
COPY ./redis-app.py /
RUN pip install redis
WORKDIR /
CMD ["python3", "redis-app.py"]
```

```bash
docker build -t py-redis:1.0 .
docker images | grep py
docker run -itd --name=redis-py py-redis:1.0
docker ps -a
docker exec -it redis-db redis-cli -a 패스워드
```

```redis
set key1 value1
keys *
get key1
/////// redis-app.py 실행 후
keys *
get cloud
```

### Env - Ubuntu

```bash
$ docker run -it -e JAVA_HOME=/java/jre1.0 ubuntu:14.04 bash
 @ set
 > ...
 > JAVA_HOME=/java/jre1.0

$ docker run -it -e JAVA_HOME=/java/jre1.0 -e JAVA_JVM=/java/jvm1.0 ubuntu:14.04 bash
 @ set
 > ...
 > JAVA_HOME=/java/jre1.0
 > JAVA_JVM=/java/jvm1.0

$ vi env_list

ORACLE_SID=orcl
ORACLE_BASE=/u01/app/oracle
ORACLE_HOME=/u01/app/oracle/product/12.2.0/db_1
JAVA_HOME=/java/jre2.0
JAVA_JVM=/java/jvm2.0

$ docker run -it --env-file=env_list ubuntu:14.04 bash
 @ env | grep ORACLE
 > ORACLE_SID=orcl
 > ORACLE_BASE=/u01/app/oracle
 > ORACLE_HOME=/u01/app/oracle/product/12.2.0/db_1
 @ env | grep JAVA
 > JAVA_JVM=/java/jvm2.0
 > JAVA_HOME=/java/jre2.0

$ docker run -it --name=webserver6 \
  -p 8006:80 -w=/usr/share/nginx/html nginx:1.23.3 sh # -w | --workdir 
 @ pwd
 > /usr/share/nginx/html
```

### Log - Ubuntu

> 실시간(Stream)으로 로그를 확인하는 법을 확인한다.

> Container Stop 시 자동으로 삭제되는 옵션을 확인한다.

```bash
$ docker run -d --rm ubuntu:14.04 ping localhost  # --rm : docker stop 시 자동 삭제
$ docker logs -f db68b50
$ docker stop lucid_ritchie     # 자동 삭제
```

### Copy - Nginx

> docker cp 명령어가 Host-Container Container-Container 에서 양방향 Copy가 가능함을 이해한다.

> Container는 가벼워야 한다! -> Container 내부에 패키지 설치 지양! -> vi편집기 설치 안됨. -> docker cp 사용

```bash
$ docker run -d -p 8009:80 --name=webserver9 nginx:1.23.3-alpine
$ docker cp webserver:/etc/nginx/nginx.conf /home/kevin/nginx.conf    
$ vi ~/nginx.conf
$ docker cp nginx.conf webserver:/etc/nginx/nginx.conf 
```

# Inspect - Apache2

> docker image inspect 명령어로 내부 구조 정보를 확인함을 이해한다.

```bash
$ docker image inspect httpd:2.4
>        "Container": "30df81c7e4e9fcec6990ff7a5aee09f0b8d765a65d575599d92fa3d2c2da6048",
```

















		ㄴ Dockerfile build -> line 1 단위로 실행 -> image 불변(RO) -> container1로 실행
				-> image로 저장 -> line 2 -> container2로 실행
				-> image로 저장 -> container2 삭제 -> line 3 ...
				-> 최종 containerID -> 최종 imageID로 저장
	
        최종 container id -> 최종imageID로 저장



```txt
/LABs/python$ sudo -i
root@hostos1:~# find / -name py_lotto.py

root@hostos1:/var/lib/docker/overlay2/5d15d4336c194c7e840bb5ceb7438d4d97e0f116f9ad8a02f934ab622d15b05a/merged# ls
bin   dev  home  lib64  mnt  proc         root  sbin  sys  usr
boot  etc  lib   media  opt  py_lotto.py  run   srv   tmp  var
======================================================================================
$ docker exec -it py-test bash
root@996f7684b8a5:/# ls
bin   dev  home  lib64  mnt  proc         root  sbin  sys  usr
boot  etc  lib   media  opt  py_lotto.py  run   srv   tmp  var
```

2. image 해부

```bash
$ docker pull docker.io/library/debian:10
$ docker pull httpd:2.4
> 3f9582a2cbe7: Already exists		# local (/var/lib/docker) 에 존재
> 9423d69c3be7: Pull complete		  # new layer
> d1f584c02b5d: Pull complete
> 758a20a64707: Pull complete
> 08507f82f391: Pull complete
> Digest: sha256:76618ddd53f315a1436a56dc84ad57032e1b2123f2f6489ce9c575c4b280c4f4 # merge!

$ docker pull gcr.io/google-samples/hello-app:1.0
> 1.0: Pulling from google-samples/hello-app
> fbad7aa519f7: Pull complete
> fda4ba87f6fb: Pull complete
> 74c357f2d0d6: Pull complete
> Digest: sha256:845f77fab71033404f4cfceaa1ddb27b70c3551ceb22a5e7f4498cdda6c9daea
> Status: Downloaded newer image for gcr.io/google-samples/hello-app:1.0
> gcr.io/google-samples/hello-app:1.0
```

> Dockerfile로 변환 시켜주는 방법도 가능
