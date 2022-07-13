ARG VERSION=11 DBNAME='db_lsnet'

FROM debian:${VERSION}

LABEL creator="Nick0tin"

 
RUN apt-get update  \
    && apt-get install -y postgresql-13  \  
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN service postgresql start \
    && su - postgres -c "createdb db_lsnet" \
    && su - postgres -c 'psql -d db_lsnet -c "CREATE TABLE accounts (user_id serial PRIMARY KEY, \
    username VARCHAR ( 50 ) UNIQUE NOT NULL, password VARCHAR ( 50 ) \
    NOT NULL, email VARCHAR ( 255 ) UNIQUE NOT NULL,created_on TIMESTAMP NOT NULL, last_login TIMESTAMP );"' \
    && service postgresql stop

USER postgres
RUN echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/13/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/13/main/postgresql.conf


#VOLUME [ "/backup-content" ]

ENV EDITOR /usr/bin/vi

#WORKDIR /var/www

#COPY /nginx-v1/index.html /var/www/html/ 

# POSTGRESQL TCP/IP Port 
EXPOSE 5432 

#HEALTHCHECK --interval=10s --timeout=5s  CMD curl --fail http://localhost:80/ || exit 1

STOPSIGNAL SIGQUIT
VOLUME ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
CMD ["/usr/lib/postgresql/13/bin/postgres", "-D", "/etc/postgresql/13/main/" ]
