FROM bcit/puppetserver

ENV RUNUSER=puppetdb
ENV PUPPETDB_JAVA_ARGS="-Djava.net.preferIPv4Stack=true -Xms256m -Xmx256m"
ENV PUPPETDB_DATABASE_CONNECTION=//postgres:5432/puppetdb
ENV PUPPETDB_USER=puppetdb
ENV PUPPETDB_PASSWORD=puppetdb
ENV PUPPET_CERTNAME=puppetdb
ENV PUPPET_CERT_ALTNAMES="puppetdb.puppet.svc"

RUN [ -f /docker-entrypoint.d/50-production.sh ] && rm -f /docker-entrypoint.d/50-production.sh

RUN tar zxf /opt/puppetlabs/server.tar.gz -C /opt/puppetlabs

RUN yum -y install \
        puppetdb \
 && rm -rf /var/cache/yum

COPY foreground /opt/puppetlabs/server/apps/puppetdb/cli/apps/foreground
RUN chmod 755 /opt/puppetlabs/server/apps/puppetdb/cli/apps/foreground

RUN tar czf /opt/puppetlabs/server.tar.gz -C /opt/puppetlabs server \
 && rm -rf /opt/puppetlabs/server \
 && chown 0:0 /opt/puppetlabs \
 && chmod 775 /opt/puppetlabs

COPY 10-resolve-userid.sh /docker-entrypoint.d/10-resolve-userid.sh

COPY sysconfig-puppetdb /etc/sysconfig/puppetdb
RUN chmod 775 /etc/sysconfig \
 && chmod 664 /etc/sysconfig/puppetdb

COPY logging /etc/puppetlabs/puppetdb/logging

RUN rm -rf /etc/puppetlabs/puppetdb/conf.d
COPY conf.d /etc/puppetlabs/puppetdb/conf.d

RUN chmod    775 /opt/puppetlabs /etc/puppetlabs \
 && chown -R 0:0 /opt/puppetlabs /etc/puppetlabs \
 && find /opt/puppetlabs /etc/puppetlabs -type d | xargs chmod 775 \
 && find /opt/puppetlabs /etc/puppetlabs -type f | xargs chmod 664

EXPOSE 8080 8081
HEALTHCHECK CMD true

CMD [ "/opt/puppetlabs/bin/puppetdb", "foreground" ]
