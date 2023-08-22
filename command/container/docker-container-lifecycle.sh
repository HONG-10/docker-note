##########################################################################
# Docker Container Lifecycle
##########################################################################

# Docker Container 생성
$ docker create

# Docker Container 시작 & 정지 & 재시작
$ docker start

$ docker stop [CONTAINER_NM]
$ docker stop $(docker ps -q)
$ docker stop $(docker ps -a -q)

$ docker restart

# Docker Container Run([pull] + Create + Start)
$ docker run
$ docker run -d \
    --restart=unless-stopped \
    --name module-www-production \
    -p 8080:8080 \
    -v /data/shared/onilifo/files \
    nexus:17080/module-www-production:[IMAGE_VERSION]

#* Options
#* -i                       interactive, 대화식
#* -t                       tty, 터미널
#* -d                       detach, 백그라운드 실행 (곧바로 수행 가능한 경우) / exit 해도 cotainer 안죽음.
#! -it                      컨테이너 내부 작업이 필요한 경우
#! -itd                     백그라운드로 실행 & 컨테이너 내부 진입
#@ -u                       사용자 생성하여 application 수행, kevin
#@ -v                       볼륨
#@ -w | --workdir           작업공간 지정
#@ -e                       환경변수
#@ --envfile                환경변수 파일 지정
#@ --name		            container name
#@ --rm		                docker stop 과 동시에 container(image snapshot) 자동 삭제
#@ --restart                { =always | =no(Default) }, 예기치 않은 종료 시 자동 재시작. 단, docker stop 제외
#? --add-host	            /etc/hosts에 신뢰하는 서버 정보 등록
#? --dns		            /etc/resolve.conf 설정과 동일
#? -h			            hostname 설정
#? --mac-address            MAC address 지정
#? -p			            publish(게시), 명시적 포트 매핑 -> 8001(host):80(container)
#? -P			            암시적(32767~) 포트 매핑 -> container내부의 expose port자동연결
#? --link                   
#? --expose		            추가로 포트 open -> 관리용 포트
#? --net		            Network Plugin | 사용자 정의 네트워크 이름 (bridge, host, ipvlan macvlan, overlay)
#? --net=host               Container가 Host Network에 연결 (LB 활용)
#? --net=null               Network 샌드박스를 만들지 않음


# All Options
# --add-host		            Add a custom host-to-IP mapping (host:ip)
# --attach , -a		            Attach to STDIN, STDOUT or STDERR
# --blkio-weight		        Block IO (relative weight), between 10 and 1000, or 0 to disable (default 0)
# --blkio-weight-device		    Block IO weight (relative device weight)
# --cap-add		                Add Linux capabilities
# --cap-drop		            Drop Linux capabilities
# --cgroup-parent		        Optional parent cgroup for the container
# --cgroupns		            [API 1.41+] Cgroup namespace to use (host|private) ‘host’: Run the container in the Docker host’s cgroup namespace ‘private’: Run the container in its own private cgroup namespace ‘’: Use the cgroup namespace as configured by the default-cgroupns-mode option on the daemon (default)
# --cidfile		                Write the container ID to the file
# --cpu-count		            CPU count (Windows only)
# --cpu-percent		            CPU percent (Windows only)
# --cpu-period		            Limit CPU CFS (Completely Fair Scheduler) period
# --cpu-quota		            Limit CPU CFS (Completely Fair Scheduler) quota
# --cpu-rt-period		        Limit CPU real-time period in microseconds
# --cpu-rt-runtime		        Limit CPU real-time runtime in microseconds
# --cpu-shares , -c		        CPU shares (relative weight)
# --cpus		                Number of CPUs
# --cpuset-cpus		            CPUs in which to allow execution (0-3, 0,1)
# --cpuset-mems		            MEMs in which to allow execution (0-3, 0,1)
# --detach , -d		            Run container in background and print container ID
# --detach-keys		            Override the key sequence for detaching a container
# --device		                Add a host device to the container
# --device-cgroup-rule		    Add a rule to the cgroup allowed devices list
# --device-read-bps		        Limit read rate (bytes per second) from a device
# --device-read-iops		    Limit read rate (IO per second) from a device
# --device-write-bps		    Limit write rate (bytes per second) to a device
# --device-write-iops		    Limit write rate (IO per second) to a device
# --disable-content-trust		Skip image verification                                 #@ Default: true
# --dns		                    Set custom DNS servers
# --dns-option		            Set DNS options
# --dns-search		            Set custom DNS search domains
# --domainname		            Container NIS domain name
# --entrypoint		            Overwrite the default ENTRYPOINT of the image
# --env , -e		            Set environment variables
# --env-file		            Read in a file of environment variables
# --expose		                Expose a port or a range of ports
# --gpus		                [API 1.40+]GPU devices to add to the container (‘all’ to pass all GPUs)
# --group-add		            Add additional groups to join
# --health-cmd		            Command to run to check health
# --health-interval		        Time between running the check (ms|s|m|h) (default 0s)
# --health-retries		        Consecutive failures needed to report unhealthy
# --health-start-period		    Start period for the container to initialize before starting health-retries countdown (ms|s|m|h) (default 0s)
# --health-timeout		        Maximum time to allow one check to run (ms|s|m|h) (default 0s)
# --help		                Print usage
# --hostname , -h		        Container host name
# --init		                Run an init inside the container that forwards signals and reaps processes
# --interactive , -i		    Keep STDIN open even if not attached
# --io-maxbandwidth		        Maximum IO bandwidth limit for the system drive (Windows only)
# --io-maxiops		            Maximum IOps limit for the system drive (Windows only)
# --ip		                    IPv4 address (e.g., 172.30.100.104)
# --ip6		                    IPv6 address (e.g., 2001:db8::33)
# --ipc		                    IPC mode to use
# --isolation		            Container isolation technology
# --kernel-memory		        Kernel memory limit
# --label , -l		            Set meta data on a container
# --label-file		            Read in a line delimited file of labels
# --link		                Add link to another container
# --link-local-ip		        Container IPv4/IPv6 link-local addresses
# --log-driver		            Logging driver for the container
# --log-opt		                Log driver options
# --mac-address		            Container MAC address (e.g., 92:d0:c6:0a:29:33)
# --memory , -m		            Memory limit
# --memory-reservation		    Memory soft limit
# --memory-swap		            Swap limit equal to memory plus swap: ‘-1’ to enable unlimited swap
# --memory-swappiness	        Tune container memory swappiness (0 to 100)             #@ Default: -1
# --mount		                Attach a filesystem mount to the container
# --name		                Assign a name to the container
# --network		                Connect a container to a network
# --network-alias		        Add network-scoped alias for the container
# --no-healthcheck		        Disable any container-specified HEALTHCHECK
# --oom-kill-disable		    Disable OOM Killer
# --oom-score-adj		        Tune host’s OOM preferences (-1000 to 1000)
# --pid		                    PID namespace to use
# --pids-limit		            Tune container pids limit (set -1 for unlimited)
# --platform		            Set platform if server is multi-platform capable
# --privileged		            Give extended privileges to this container
# --publish , -p		        Publish a container’s port(s) to the host
# --publish-all , -P		    Publish all exposed ports to random ports
# --pull	                    Pull image before running (always, missing, never)      #@ Default: missing
# --quiet , -q		            Suppress the pull output
# --read-only		            Mount the container’s root filesystem as read only
# --restart		                Restart policy to apply when a container exits          #@ Default: no
# --rm		                    Automatically remove the container when it exits
# --runtime		                Runtime to use for this container
# --security-opt		        Security Options
# --shm-size		            Size of /dev/shm
# --sig-proxy                   Proxy received signals to the process                   #@ Default: true
# --stop-signal		            Signal to stop the container
# --stop-timeout		        Timeout (in seconds) to stop a container
# --storage-opt		            Storage driver options for the container
# --sysctl		                Sysctl options
# --tmpfs		                Mount a tmpfs directory
# --tty , -t		            Allocate a pseudo-TTY
# --ulimit		                Ulimit options
# --user , -u		            Username or UID (format: <name|uid>[:<group|gid>])
# --userns		                User namespace to use
# --uts		                    UTS namespace to use
# --volume , -v		            Bind mount a volume
# --volume-driver		        Optional volume driver for the container
# --volumes-from		        Mount volumes from the specified container(s)
# --workdir , -w		        Working directory inside the container

# Docker Container 일지정지 & 일지정지 해제
$ docker pause
$ docker unpause

# Docker Container 강제 종료
$ docker kill

#! Linux Command kill -9 : Container Session Kill (--restart=always 시 자동으로 살아남)
#! Docker Command kill : Container Force quit | exited(137)

# Docker Container 삭제
$ docker rm

$ docker rm $(docker ps --filter 'status=exited' -a -q)
