# Docker Day 3
## Docker Resource Limit

### Docker Resource Limit - Intro

> Container 생성 시 제공되는 Resource(CPU, Memory, Disk)는 무제한으로 HostOS에서 가져온다.

* docker updtae			| Resource Spec 변경
* docker run [OPTIONS]	| 생성 시 제공 되는 Resource 제한 설정

### Docker Resource Limit - CPU

> CPU 동작 | Time Scheduling (RR: 1024)

* CPU | 동작
	* --cpu-shares (=time값 지정 ex. 2048)
	* --cpuset-cpus (CPU & CPU Core 번호로 지정 ex. 0 / 0,2 / 1-3  지정된 CPU 100% 사용가능)
	* --cpus (% 비율 지정)

### Docker Resource Limit - Memory

> Memory 구성 | Physical Memory & Swap Memory

> Swap Memory | process 대기장소, 실제작업 수행 못함! ,일반적으로 swap은 물리적 메모리의 2배

* Memory (MB, GB)
	* -m | --memory
* Swap Memory (disk or file)
	* --memory-swap

### Docker Resource Limit - Disk

> Disk 성능 지표 | IOPS & MBPS

* IOPS | 초당 I/O 횟수
	* --device-read-iops (KB_read/s) 
	* --device-write-iops (KB_wrtn/s)
* MBPS | 초당 처리량
	* --device-read-bps (KB_read)
	* --device-write-bps (KB_wrtn)

```bash
$ docker run -it --rm ubuntu:14.04 bash
 @ dd if=/dev/zero of=test.out bs=1M count=10 oflag=direct
 > 10+0 records in
 > 10+0 records out
 > 10485760 bytes (10 MB) copied, 0.0446931 s, 235 MB/s

$ docker run -it --rm --device-write-bps /dev/sdb:1mb ubuntu:14.04 bash
 @ dd if=/dev/zero of=test.out bs=1M count=10 oflag=direct
 > 10+0 records in
 > 10+0 records out
 > 10485760 bytes (10 MB) copied, 10.0222 s, 1.0 MB/s

$ docker run -it --rm --device-write-bps /dev/sdb:10mb ubuntu:14.04 bash
 @ dd if=/dev/zero of=test.out bs=1M count=10 oflag=direct
 > 10+0 records in
 > 10+0 records out
 > 10485760 bytes (10 MB) copied, 1.01312 s, 10.3 MB/s
```
