FROM bcit/openshift-puppetserver:6.6.0
LABEL maintainer="jesse_weisner@bcit.ca"
LABEL puppetdb_version="6.6.0"
LABEL build_id="1569002275"

ENV RUNUSER=puppetdb
ENV PUPPETDB_JAVA_ARGS="-Xmx192m"
ENV PUPPETDB_DATABASE_CONNECTION=//postgres:5432/puppetdb
ENV PUPPETDB_USER=puppetdb
ENV PUPPETDB_PASSWORD=puppetdb
ENV PUPPET_CERTNAME=puppetdb
ENV PUPPET_CERT_ALTNAMES="puppetdb.puppet.svc"

RUN [ -f /docker-entrypoint.d/50-production.sh ] && rm -f /docker-entrypoint.d/50-production.sh

RUN tar zxf /opt/puppetlabs/server.tar.gz -C /opt/puppetlabs

RUN yum -y install \
        puppetdb-6.6.0 \
 && rm -rf /var/cache/yum

RUN userdel puppetdb

COPY foreground /opt/puppetlabs/server/apps/puppetdb/cli/apps/foreground
RUN chmod 755 /opt/puppetlabs/server/apps/puppetdb/cli/apps/foreground

COPY ssl-setup /opt/puppetlabs/server/apps/puppetdb/cli/apps/ssl-setup
RUN chmod 755 /opt/puppetlabs/server/apps/puppetdb/cli/apps/ssl-setup

RUN tar czf /opt/puppetlabs/server.tar.gz -C /opt/puppetlabs server \
 && rm -rf /opt/puppetlabs/server \
 && chown 0:0 /opt/puppetlabs \
 && chmod 775 /opt/puppetlabs

COPY 70-ssl-setup.sh /docker-entrypoint.d/
COPY 70-database-config.sh /docker-entrypoint.d/

COPY sysconfig-puppetdb /etc/sysconfig/puppetdb
RUN chmod 775 /etc/sysconfig \
 && chmod 664 /etc/sysconfig/puppetdb

COPY database.ini.template /etc/puppetlabs/puppetdb/conf.d/database.ini
COPY jetty.ini /etc/puppetlabs/puppetdb/conf.d/jetty.ini

RUN chmod    775 /opt/puppetlabs /etc/puppetlabs \
 && chown -R 0:0 /opt/puppetlabs /etc/puppetlabs \
 && find /opt/puppetlabs /etc/puppetlabs -type d | xargs chmod g+rwx \
 && find /opt/puppetlabs /etc/puppetlabs -type f | xargs chmod g+rw

COPY healthcheck-puppetdb.sh /
RUN chmod 555 /healthcheck-puppetdb.sh

EXPOSE 8080 8081

CMD [ "/opt/puppetlabs/bin/puppetdb", "foreground" ]
