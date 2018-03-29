FROM bcit/puppetserver

ENV RUNUSER=puppetdb
ENV PUPPETDB_JAVA_ARGS="-Djava.net.preferIPv4Stack=true -Xms256m -Xmx256m"
ENV PUPPETDB_DATABASE_CONNECTION=//postgres:5432/puppetdb
ENV PUPPETDB_USER=puppetdb
ENV PUPPETDB_PASSWORD=puppetdb

RUN mv /opt/puppetlabs/skel-server/* /opt/puppetlabs/server/

RUN yum -y install \
        puppetdb \
 && rm -rf /var/cache/yum

RUN chmod    775 /opt/puppetlabs /etc/puppetlabs \
 && chown -R 0:0 /opt/puppetlabs /etc/puppetlabs \
 && find /opt/puppetlabs /etc/puppetlabs -type d | xargs chmod g+rwx \
 && find /opt/puppetlabs /etc/puppetlabs -type f | xargs chmod g+rw

RUN mv /opt/puppetlabs/server/* /opt/puppetlabs/skel-server/ \
 && chown 0:0 /opt/puppetlabs/server \
 && chmod 775 /opt/puppetlabs/server

COPY 10-resolve-userid.sh /docker-entrypoint.d/10-resolve-userid.sh

COPY foreground /opt/puppetlabs/skel-server/apps/puppetdb/cli/apps/foreground
RUN chmod 755 /opt/puppetlabs/skel-server/apps/puppetdb/cli/apps/foreground

COPY sysconfig-puppetdb /etc/sysconfig/puppetdb
RUN chmod 775 /etc/sysconfig \
 && chmod 664 /etc/sysconfig/puppetdb

COPY logging /etc/puppetlabs/puppetdb/logging

RUN rm -rf /etc/puppetlabs/puppetdb/conf.d
COPY conf.d /etc/puppetlabs/puppetdb/conf.d

EXPOSE 8080 8081
HEALTHCHECK CMD true

CMD [ "/opt/puppetlabs/bin/puppetdb", "foreground" ]
