FROM ubuntu:14.04.3

MAINTAINER "Giovanni Colapinto" alfheim@syshell.net

RUN rm -rf /var/lib/apt/lists/ \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    supervisor \
    sudo \
    graphite-web \
    graphite-carbon \
    postgresql-client \
    libpq-dev \
    python-psycopg2 \
    apache2 \
    libapache2-mod-wsgi \
    mysql-client \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./graphite_conf/* /etc/graphite/
COPY ./carbon_conf/* /etc/carbon/
COPY ./default_conf/* /etc/default/
COPY ./docker-entrypoint.sh /
COPY ./apache_conf/apache2-graphite.conf /etc/apache2/sites-available/

RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor

RUN a2dissite 000-default && a2ensite apache2-graphite

RUN chmod 755 /docker-entrypoint.sh

# Apache
EXPOSE 80
# Carbon line receiver port
EXPOSE 2003
# Carbon pickle receiver port
EXPOSE 2004
# Carbon cache query port
EXPOSE 7002

ENTRYPOINT /docker-entrypoint.sh
