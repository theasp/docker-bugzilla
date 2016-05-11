# docker-bugzilla
docker for bugzilla 4.4

# example docker-compose.yml

```
version: '2'
services:

  bugzilla:
    restart: always
    image: froque/docker-bugzilla
    links:
      - database:mysql-host
    ports:
      - "8080:80"
    depends_on:
      - "database"
    environment:
      - MYSQL_DB=bugs
      - MYSQL_USER=root
      - MYSQL_PWD=somepassword

  database:
    restart: always
    image: mysql:5.5
    environment:
      - MYSQL_ROOT_PASSWORD=somepassword
```
