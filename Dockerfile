FROM bcit/puppetserver

ENV PUPPETDB_JAVA_ARGS="-Djava.net.preferIPv4Stack=true -Xms256m -Xmx256m"
ENV PUPPETDB_DATABASE_CONNECTION=//postgres:5432/puppetdb
ENV PUPPETDB_USER=puppetdb
ENV PUPPETDB_PASSWORD=puppetdb

RUN yum -y install \
        puppetdb \
 && rm -rf /var/cache/yum

COPY sysconfig-puppetdb /etc/sysconfig/puppetdb

COPY logging /etc/puppetlabs/puppetdb/logging

RUN rm -rf /etc/puppetlabs/puppetdb/conf.d
COPY conf.d /etc/puppetlabs/puppetdb/conf.d

EXPOSE 8080 8081
HEALTHCHECK CMD true

CMD [ "/opt/puppetlabs/bin/puppetdb", "foreground" ]
