FROM mariadb:10.3

COPY galera-entrypoint.sh /

RUN apt-get update && \
	apt-get install -y galera-arbitrator-3 && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 3306 4444 4567 4567/udp 4568

ENTRYPOINT ["/galera-entrypoint.sh"]
CMD ["mysqld"]