# Docker Day 4
## Docker Compose

### Docker Compose Build 이해

* IaC | .yaml 기반
    - 들여쓰기 주의
    - 코드 상하관계에 대한 들여쓰기 규칙 (2칸 권장, 동일하게 들여쓰면 칸수 관계 X)
    - Tab 사용 금지

* MSA | one more container (1개 이상) 지향
    - 1개 Container에 N개 Application (All-in-one Container) 지양
    - 1개 Container에 1개 Application 지향
    - 1개씩 컨테이너를 띄우는 것 비효율적
    - Multi Container Services 지향

> Multi Container 번거로움 --> Docker Compose의 탄생

```bash
docker run -d \
    --name=backend \
    --network=devapp-net \
    --restart=always \
    -e PORT=8000 \
    -e GUESTBOOK_DB_ADDR=mongodb:27017 \
    leecloudo/guestbook:backend_1.0

docker run -d \
    --name=frontend \
    --network=devapp-net \
    --restart=always \
    -p 3000:8000 \
    -e PORT=8000 \
    -e GUESTBOOK_API_ADDR=backend:8000 \
    leecloudo/guestbook:frontend_1.0

docker logs -f frontend
```

### docker-compose.yaml 작성법

> docker-compose.yaml

> mysql & wordpress 2-Tier Services 구축

```yaml
version: "3.9"          # docker version
services:               # service(x) services (o) Multi Container Service 지향
  mydb:                 # Service Name
    image: mysql:8.0    # Base Image
    container_name: mysql_app
    volumes:
      - mydb_data:/var/lib/mysql
    restart: always
    networks:
      - backend-net
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: wordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
  myweb:
    depends_on:
      - mydb
    image: wordpress:latest
    container_name: wordpress_app
    networks: 
      - frontend-net
      - backend-net
    ports:
        - "8888:80"
    volumes:
      - myweb_data:/var/www/html
      - $(PWD)/myweb-log:/var/log
    restart: always
    environment:
      WORDPRESS_DB_HOST: mydb:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
networks: 
  frontend-net: {}
  backend-net: {}
volumes:
  mydb_data: {}
  myweb_data: {}
```

```bash
docker volume create mydb_data
docker volume create myweb_data
docker network create myapp-net

docker run -itd \
> --name=mysql_app \
> -v mydb_data:/var/lib/mysql \
> --restart=always \
> -p 3306:3306 \
> --net=myapp-net \
> -e MYSQL_ROOT_PASSWORD=password# \
> -e MYSQL_DATABASE=wpdb \
> -e MYSQL_USER=wpuser \
> -e MYSQL_PASSWORD=wppassword \
> mysql:8.0

docker run -itd \
> --name=wordpress_app \
> -v myweb_data:/var/www/html \
> -v ${PWD}/myweb-log:/var/log \
> --restart=always \
> -p 8888:80 \
> --net=myapp-net \
> -e WORDPRESS_DB_HOST=mysql_app:3306 \
> -e WORDPRESS_DB_NAME=wpdb \
> -e WORDPRESS_DB_USER=wpuser \
> -e WORDPRESS_DB_PASSWORD=wppassword \
> --link mysql_app:mysql \
> wordpress

docker ps
docker exec -it mysql_app bash

 @ mysql -uroot -p
  ^ show databases;
  ^ use wpdb;
  ^ show tables;
  # web data insert
  ^ show tables;
  ^ select * from wp_users;
```

### Docker Compose Command


### Docker Compose Best Practieces


### Docker Compose Reference
* https://www.yamllint.com/
* https://docs.docker.com/compose/install/linux/
* indent | 들여쓰기 중요
