# Docker Day 3
## Docker Network

### Docker Network Info

```bash
$ sudo iptables -t nat -L -n
> Chain PREROUTING (policy ACCEPT)
> target     prot opt source               destination
> DOCKER     all  --  0.0.0.0/0            0.0.0.0/0            ADDRTYPE match dst-type LOCAL

> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination

> Chain OUTPUT (policy ACCEPT)
> target     prot opt source               destination
> DOCKER     all  --  0.0.0.0/0           !127.0.0.0/8          ADDRTYPE match dst-type LOCAL

> Chain POSTROUTING (policy ACCEPT)
> target     prot opt source               destination
> MASQUERADE  all  --  172.17.0.0/16        0.0.0.0/0
> MASQUERADE  tcp  --  172.17.0.8           172.17.0.8           tcp dpt:80
> MASQUERADE  tcp  --  172.17.0.9           172.17.0.9           tcp dpt:80
> MASQUERADE  tcp  --  172.17.0.4           172.17.0.4           tcp dpt:3306
> MASQUERADE  tcp  --  172.17.0.7           172.17.0.7           tcp dpt:80
> MASQUERADE  tcp  --  172.17.0.11          172.17.0.11          tcp dpt:6379
> MASQUERADE  tcp  --  172.17.0.5           172.17.0.5           tcp dpt:8900
> MASQUERADE  tcp  --  172.17.0.6           172.17.0.6           tcp dpt:8080

> Chain DOCKER (2 references)
> target     prot opt source               destination
> RETURN     all  --  0.0.0.0/0            0.0.0.0/0
> DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:8002 to:172.17.0.8:80
> DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:8003 to:172.17.0.9:80
> DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:13306 to:172.17.0.4:3306
> DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:8001 to:172.17.0.7:80
> DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:6379 to:172.17.0.11:6379
> DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:8900 to:172.17.0.5:8900
> DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:9559 to:172.17.0.6:8080

$ sudo netstat -nlp | grep 8001
> tcp        0      0 0.0.0.0:8001        0.0.0.0:*      LISTEN      173065/docker-proxy
$ ps -ef | grep 173065
> root      173065    1158  0 10:11 ?        00:00:00 /usr/bin/docker-proxy -proto tcp -host-ip 0.0.0.0 -host-port 8001 -container-ip 172.17.0.3 -container-port 80
> kevin     174211  164543  0 10:24 pts/0    00:00:00 grep --color=auto 173065
```

### Docker Network Host Connection

> --net=host는 container가 host network에 연결된다.

```bash
$ docker run -d --name=myweb-host --net=host nginx:1.23.3-alpine
$ docker port myweb-host
$ sudo netstat -nlp | grep 80
> tcp        0      0 0.0.0.0:80              0.0.0.0:*      LISTEN      179805/nginx: maste
$ curl localhost:80
$ docker inspect myweb-host | grep -i ipa
>             "SecondaryIPAddresses": null,
>             "IPAddress": "",
>                     "IPAMConfig": null,
>                     "IPAddress": "",
$ brctl show
> bridge name     bridge id               STP enabled     interfaces
> br-1bf7abf50a74         8000.0242f0c57ae7       no      vethac42cb9	-> net-check1
```

### Docker Network Container Connection

> docker0를 제외한 "사용자 정의 네트워크"에 연결된 컨테이너들은 "상호간의 컨테이너이름"으로 통신이 가능하다!
> bridge는 software적으로 구현된 가상의 switch와 같고, 자체 DHCP pool을 보유한다.
	# 172.17.x.x -> 172.18.x.x -> 172.19.x.x
	   ㄴ	         	rm -> reuse? O
	   ㄴ 내부 컨테이너 삭제 시 해당 IP도 reuse O
> 사용자 정의 네트워크 -> 대역 지정 -> 반드시 CIDR 기법으로만 가능


### Docker Network Container Proxy

> Container Proxy -> Switch -> Load Balancer(LB)

> Container에서 등록된 DNS 정보를 확인하여 통신하는 것을 이해한다.

* Docker Self Load Balancer
    * service discovery (docker DNS) | 127.0.0.11

    * Rule 1. 사용자 정의 네트워크 사용 | docker network create [NETWORK_NM] & --net (--network)
    * Rule 2. Target Group (대상 지정) | --net-alias (--network-alias)
    
    * dig(Domain Information Groper) 통해서 docker DNS 확인

* docker reference 등록된 정보 (RR -> random)

```bash
$ docker network create \
    --driver bridge \
    --subnet 172.200.1.0/24 \
    --ip-range 172.200.1.0/24 \
    --gateway 172.200.1.1 \
    netlb

$ docker run -itd --name=nettest1 --net=netlb --net-alias=tg-net ubuntu:14.04
$ docker run -itd --name=nettest2 --net=netlb --net-alias=tg-net ubuntu:14.04
$ docker run -itd --name=nettest3 --net=netlb --net-alias=tg-net ubuntu:14.04

$ docker ps
$ docker inspect nettest1 | grep -i ipa   # "IPAddress": "172.200.1.2",
$ docker inspect nettest2 | grep -i ipa
$ docker inspect nettest3 | grep -i ipa

$ docker run -it --name=frontend --net=netlb ubuntu:14.04 bash
 @ ping -c 2 tg-net
 > PING tg-net (172.200.1.4) 56(84) bytes of data.
 > 64 bytes from nettest3.netlb (172.200.1.4): icmp_seq=1 ttl=64 time=0.112 ms
 @ apt update
 @ apt -y install dnsutils
 @ dig tg-net
 > ;; QUESTION SECTION:
 > ;tg-net.                                IN      A
 > ;; ANSWER SECTION:
 > tg-net.                 600     IN      A       172.200.1.2
 > tg-net.                 600     IN      A       172.200.1.3
 > tg-net.                 600     IN      A       172.200.1.4


# 2 터미널
$ docker run -itd --name=nettest4 --net=netlb --net-alias tg-net ubuntu:14.04
# 2 터미널 종료

 @ dig tg-net
 > tg-net.                 600     IN      A       172.200.1.6
 @ ping -c 2 tg-net

$ docker inspect nettest1
            "Networks": {
                "netlb": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": [
                        "tg-net",
                        "3983df3e4d3a"
```


```bash
# Nginx HostOS 설치
$ sudo apt -y install nginx
$ sudo netstat -nlp | grep 80
$ sudo nginx -v
$ sudo systemctl status nginx.service
$ docker run -itd --name=alb-node01 \
    -e SERVER_PORT=5001 \
    -p 5001:5001 \
    -h alb-node01 \
    -u root \
    dbgurum/nginxlb:1.0

$ docker run -itd --name=alb-node02 \
    -e SERVER_PORT=5002 \
    -p 5002:5002 \
    -h alb-node02 \
    -u root \
    dbgurum/nginxlb:1.0

$ docker run -itd --name=alb-node03 \
    -e SERVER_PORT=5003 \
    -p 5003:5003 \
    -h alb-node03 \
    -u root \
    dbgurum/nginxlb:1.0

$ sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.org
$ sudo vi /etc/nginx/nginx.conf
```
```conf
events { 
    worker_connections 1024;
}
http {

    # Target Group | --net-alias
    upstream backend-alb {
        server 127.0.0.1:5001;
        server 127.0.0.1:5002;
        server 127.0.0.1:5003;
    }
    server {

        listen 80  default_server;
        
        location / {
            proxy_pass http://backend-alb;
        }

    }

}
```
```bash
$ sudo systemctl restart nginx.service
$ sudo systemctl status nginx.service
$ sudo cp /etc/nginx/nginx.conf ./LABs/nginx.conf
$ sudo systemctl stop nginx.service
$ sudo apt -y autoremove nginx
$ sudo netstat -nlp | grep 80
```
