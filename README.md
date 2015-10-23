# Toba-web 
Contenedor que tiene todas las dependencias para correr proyectos basados en SIU-Toba.
Basado en un Debian 8 con Apache y php. 

## Uso

Para la base de datos crear un docker con postgres:

```
  docker run -d --name postgres-9.4 \
	-e POSTGRES_PASSWORD=testing \
	-p 5432:5432 postgres:9.4.4
```

Para arrancar tener en cuenta el volume donde se encuentran los datos del proyecto.
La estructra que tiene el `/data`:

* `/data/local/app-toba`: donde esta la aplicacion toba
* `/data/log`: donde estan los archivos de logs
* `/data/instaladores`: para poder hacer una instalacion o un upgrade


```
  docker run -d --link postgres-9.4:db \
	-p 8080:80 -v `pwd`/toba-data/:/data \
	jsalvarredy/toba-web
```

## Reconfigurando docker con Ansible

Si se le pasa el parámetro `RECONFIGURE=1` y un archivo `all.yml` con los siguiente estructura, reconfiguramos el docker sin necesidad de volver a construirlo:
```
---
server:
    install: '1'
    docker: 1 # Poner en 1 cuando se construya un docker
    packages: [mc, vim, sudo, aspell-es, zip, locales, openjdk-7-jre]
    timezone: America/Argentina/Buenos_Aires
    locale: es_AR.UTF-8

apache:
    install: '1'
    serveradmin: toba@mydomain.edu
    servername: toba.mydomain.edu
    serveralias: www.toba.mydomain.edu
    docroot: /data/local/toba/aplicacion/www
    allowfrom: "200 192 172 127"
    apptoba: toba
    pathtoba: "/data/local/toba"
    tobainstancia: desarrollo
    pathlog: "/data/log"
    instaladores: '1'
    aliasinstaladores: "UPDATES"
    pathinstaladores: "/data/instaladores"

php:
    install: '1'
    packages: [php5-mcrypt, php5-gd, php5-pgsql, php5-curl, php5-xmlrpc]
    use_managed_ini: true
    expose_php: "Off"
    memory_limit: "256M"
    max_execution_time: "60"
    max_input_time: "60"
    max_input_vars: "15000"
    realpath_cache_size: "32K"
    upload_max_filesize: "32M"
    post_max_size: "32M"
    date_timezone: "America/Argentina/Buenos_Aires"
    sendmail_path: "/usr/sbin/sendmail -t -i"
    short_open_tag: false
    error_reporting: "E_ALL & ~E_DEPRECATED & ~E_STRICT"
    display_errors: "Off"
    display_startup_errors: "Off"
    default_charset: "ISO-8859-1"
```

Corremos el contenedor para que se reconfigure con los nuevos parámetros:

```
    docker run -d \
	-e RECONFIGURE=1 \
	-e USER_ID=`id -u` \
	--link postgres-9.4:db \
	-p 8080:80 \
	-v `pwd`/toba-data/:/data \
	-v `pwd`/all.yml:/ansible/vars/all.yml \
	jsalvarredy/toba-web
```

