FROM mariadb:10.3.9-bionic

EXPOSE 3306 4444 4567 4567/udp 4568

COPY Scripts/mariadb-entrypoint.sh /usr/local/bin/mariadb-entrypoint.sh
COPY Scripts/Discovery.sh /usr/local/bin/Discovery.sh
COPY Scripts/payload.json /usr/local/bin/payload.json
COPY Scripts/server.template.cnf /usr/local/bin/server.template.cnf

RUN apt-get update && \ 
    apt-get install -y curl jq
RUN [ "chmod", "+x" , "/usr/local/bin/mariadb-entrypoint.sh"]
RUN [ "chmod", "+x" , "/usr/local/bin/Discovery.sh"]

ENTRYPOINT [ "/usr/local/bin/mariadb-entrypoint.sh" ]
CMD ["mysqld"]