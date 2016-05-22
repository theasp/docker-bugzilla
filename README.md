# docker-bugzilla
docker for bugzilla 5.0.3

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
      - URLBASE=http://some.site.com/
      - MAINTAINER=user@example.com
      - MAILFROM=someuser@another.com
      - SMTP_PASSWORD=anotherpassword
      - SMTP_USERNAME=andathird@gmail.com

  database:
    restart: always
    image: mysql:5.5
    environment:
      - MYSQL_ROOT_PASSWORD=somepassword
```
