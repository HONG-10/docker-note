# Docker Day 1

## Docker Engine Architecture

### dockerd -> CLI(cmd)

> storage / log / network / image build 등의 관리 작업 수행

### containerd

> container lifecycle 관리
		
### runC -> runtime

> container 생성

---------------------------------------

### docker.sock -> 통신

---------------------------------------

### HostOS kernel -> LXC

> docker engine에 LXC 기술을 제공

* Network
    - External Network | NAT | apt(online package설치) | 10.0.2.15(enp0s3)
    - Internal Network | Hostonly | Infra용 | 192.168.56.xxx(enp0s8)

* Disk
    - 쓰기 속도 : xfs > ext

## Docker Network Architecture

### Docker Netwokr = Linux Network

* CNM (Container Networking Model) 
    - OS / Infra에 영향을 받지 않는 환경을 제공
    - Linux Network Building Block | Bridge, NIC, veth, iptable, route table.. 포함

    1. Bridge | L2 
        - MAC 주소 기반의 트래픽 전달
        - 주소 체계 (자동 지정): 172.{17~31}.0.0/16
        - 주소 체계 (수정 지정): 172.{111}.0.0/16
        - 192.168.x.x / 172.16.x.x / 10.0.x.x  | RFC1918 (Private Network 약속)
    
    2. Network Namespace
        - CNM 구체화
        - Sandbox 생성 | IP, MAc, NIC--pair--veth, iptable, route table ...

    3. veth | virtual ethernet
        - 터널링 서비스 제공
        - Full Duplex Link(전이중링크)

    4. iptable
        - docker all accept

    5. Endpoint
        - vethxxx--eht0 | Network Paring


### Bridge (MAC Address) Network | L2 | Local

> docker0 (Bridge Network Interface)
* 172.17.0.0/16 --> CIDR 65536개
* Gateway 172.17.0.1

> 사용자 정의 Network Interface | docker_network

```bash
$ docker run -itd --name=cotainer_1 ubuntu:14.04
$ docker inspect container_1 | grep -i ipaddress
>       "SecondaryIPAddresses": null,
>       "IPAddress": "172.17.0.2",
>               "IPAddress": "172.17.0.2",

$ docker run -itd --name=cotainer_2 ubuntu:14.04
$ docker inspect container_2 | grep -i ipaddress
>       "SecondaryIPAddresses": null,
>       "IPAddress": "172.17.0.3",
>               "IPAddress": "172.17.0.3",

$ ifconfig docker0
$ docker network ls
$ route
$ docker network inspect bridge
$ brctl show

$ docker run -itd --name=cotainer_3 ubuntu:14.04
$ docker exec -it cotainer_3 ifconfig
$ docker exec -it cotainer_3 route
$ docker exec -it cotainer_3 ip a
$ docker network inspect bridge
$ brctl show

$ sudo apt install -y iptraf-ng
$ sudo iptraf-ng
```
```bash
$ docker network create docker_network
```
### Overlay (IP Address) Network | L3 | Cluster (docker-swarm, k8s)


## Docker Driver

* Storage Driver | overlay2 --> docker volume --> container to host(container) --> NFS
* Logging Driver | json-file --> docker event -> stream 형태의 로그 기록
* Cgroup Driver | cgroupfs --> container 내부의 자원 할당 --> [참고] kubernetes --> systemd

## Docker Plugins

* Log | awslogs(-->cloudWatch) fluentd(-->EFK) gcplogs gelf journald json-file local logentries splunk syslog
* Volume | local
* Network | bridge host ipvlan macvlan null overlay --> CIDR, OSI 7
* Swarm | inactive --> kubernetes와 같은 orchestration tools -> cluster
* Runtimes | io.containerd.runc.v2 runc
