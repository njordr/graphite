# docker-graphite

Container with [graphite](http://graphite.wikidot.com/) based on ubuntu

The container is configured to use postgres or mysql as database.

Start a container with [postgresql](https://hub.docker.com/_/postgres/). Execute the following commands (docker >= 1.9):

1. docker network create network-service-01 (this will create e new network)
2. If you want to use postgres:
  * docker run --name postgres-01 -e POSTGRES_PASSWORD=vagrant -v /var/docker_data/pgsql:/var/lib/postgresql/data --net network-service-01 -d postgres (this will start postgres container)
  * docker exec -ti postgres-01 bash
  * su - postgres
  * psql
  * CREATE USER graphite WITH PASSWORD 'vagrant';
  * CREATE DATABASE graphite WITH OWNER graphite;
3. If you want to use mysql:
  * docker run --name mysql-01 -e MYSQL_ROOT_PASSWORD=vagrant --net network-service-01 -d mysql:5.5
  * docker exec -ti mysql-01 bash
  * mysql -p
  * CREATE DATABASE graphite;
  * CREATE USER 'graphite'@'%' IDENTIFIED BY 'vagrant';
  * GRANT ALL PRIVILEGES ON graphite.\* TO 'graphite'@'%';
4. Run graphite container for the first time. This will create all the databse objects needed:
  * docker run -e DBUSER="graphite" -e DBPASSWORD="vagrant" -e DBNAME="graphite" -e DBHOST="postgres-01" -e DBPORT="5432" -e ENGINE="postgres" -e FIRSTRUN="true" --net network-service-01 njordr/graphite (for postgres)
  * docker run -e DBUSER="graphite" -e DBPASSWORD="vagrant" -e DBNAME="graphite" -e DBHOST="mysql-01" -e DBPORT="3306" -e ENGINE="mysql" -e FIRSTRUN="true" --net network-service-01 njordr/graphite (for mysql)
5. Stop the container and restart it in background, WITHOUT FIRSTRUN variable
  * docker run -e DBUSER="graphite" -e DBPASSWORD="vagrant" -e DBNAME="graphite" -e DBHOST="postgres-01" -e DBPORT="5432" -e ENGINE="postgres" -d --name graphite-01 --net network-service-01 njordr/graphite (for postgres)
  * docker run -e DBUSER="graphite" -e DBPASSWORD="vagrant" -e DBNAME="graphite" -e DBHOST="mysql-01" -e DBPORT="3306" -e ENGINE="mysql" -d --name graphite-01 --net network-service-01 njordr/graphite (for mysql)


