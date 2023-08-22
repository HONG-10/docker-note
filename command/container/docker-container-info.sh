##########################################################################
# Docker Container Info
##########################################################################

# Docker Container(Process) 확인
$ docker ps

# Docker Container 내 Process 확인
$ docker top

# Docker Container Port 확인
$ docker port

# Docker Container Log 확인
$ docker logs

#? Stream Log 확인
$ docker logs -f dc4e82b5d5991c23d12aa863c2fe54beae7b586f4b7aa607bd38ec6d440ec719

# Docker Container 상태(Metric) Stream Data Live 확인
$ docker stats

# Docker Container 세부 정보 확인
$ docker inspect

$ docker inspect [CONTAINER_NM] | grep -i memory

# Docker Container 내 변경사항 확인 (image-continaer 간 변경사항)
$ docker diff
