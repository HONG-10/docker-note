##########################################################################
# Docker Container
##########################################################################

$ docker container

# ------------------------------------------------------------

# Docker Container(Process) 확인
$ docker ps

# Docker Container 내 Process 확인
$ docker top

# Docker Container Port 확인
$ docker port

# Docker Container Log 확인
$ docker logs

# Docker Container 상태(Metric) Stream Data Live 확인
$ docker stats

# Docker Container 세부 정보 확인
$ docker inspect

# Docker Container 내 변경사항 확인 (image-continaer 간 변경사항)
$ docker diff

# ------------------------------------------------------------

# Docker Container 접근
$ docker attach

# Docker Container 실행
$ docker exec

# Docker Container 이름 변경
$ docker rename

# Docker Container 내부-외부 내부-내부 COPY
$ docker cp

# Docker Container Resource Limit
$ docker update

# Docker Container export (백업) & import (복구)
$ docker export
$ docker import

# Docker Container to image
$ docker commit

# ------------------------------------------------------------

# Docker Container 생성
$ docker create

# Docker Container 시작 & 정지 & 재시작
$ docker start
$ docker stop
$ docker restart

# Docker Container Run([pull] + Create + Start)
$ docker run

# Docker Container 일지정지 & 일지정지 해제
$ docker pause
$ docker unpause

# Docker Container 강제 종료
$ docker kill

# Docker Container 삭제
$ docker rm
