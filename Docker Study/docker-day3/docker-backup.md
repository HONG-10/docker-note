# Docker Day 3
## Docker Backup

### Docker Backup Intro

> Backup : 일반적으로 정적인 상태에서 수행 (일관성, 정합성) --> Image Backup **이 일반적

> .tar (tape archive) | Package --> Image Layer Packaging (Layer라서 패키징으로 하는 것)

* tar
  - cvf | 묶음 생성
  - tvf | 묶음 조회
  - xvf | 묶음 해제

* tar.gz
  - cvzf | 묶음 생성
  - tvzf | 묶음 조회
  - xvzf | 묶음 해제

* tar.bz2
  - cvjf | 묶음 생성
  - tvjf | 묶음 조회
  - xvjf | 묶음 해제

### Docker Image Backup

> Backup & Migration & Server 이관

* docker image save
* docker image load

- Step 1. | docker image save [IMAGE_NM]:[TAG_NM] > [BACKUP_FILE_NM].tar
          | docker image save [IMAGE_NM]:[TAG_NM] | gzip > [BACKUP_FILE_NM].tar.gz
          | docker image save [IMAGE_NM]:[TAG_NM] | bzip2 > [BACKUP_FILE_NM].tar.bz2
- Step 2. | scp [BACKUP_FILE_NM].tar [USER_NM]@[HOST_NM]:[DIR_PATH]/[BACKUP_FILE_NM].tar
----------------------------------------------------------------------------------------
- Step 3. | docker image load < [BACKUP_FILE_NM].tar
- Step 4. | docker images
- Step 5. | docker run -itd [IMAGE_NM]:[TAG_NM]

### Docker Container Backup

* docker export
* docker import

- Step 1. | docker export [CONTAINER_NM] > [BACKUP_FILE_NM].tar
- Step 2. | scp [BACKUP_FILE_NM].tar [USER_NM]@[HOST_NM]:[DIR_PATH]/[BACKUP_FILE_NM].tar
----------------------------------------------------------------------------------------
- Step 3. | cat [BACKUP_FILE_NM].tar | docker import - [IMAGE_NM]:[TAG_NM]
- Step 4. | docker images
- Step 5. | docker run -itd [IMAGE_NM]:[TAG_NM]
          | > 실패 
- Step 6. | Dockerfile로 추가 작업 수행 -> build -> new image -> docker run -itd [NEW_IMAGE_NM:NEW_TAG_NM]
