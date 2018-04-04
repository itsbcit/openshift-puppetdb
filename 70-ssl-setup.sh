if [ -f /opt/puppetlabs/server/data/puppetserver/.puppetlabs/etc/puppet/ssl/certs/ca.pem ] && \
   [ -f /opt/puppetlabs/server/data/puppetserver/.puppetlabs/etc/puppet/ssl/private_keys/puppetdb.pem ] && \
   [ -f opt/puppetlabs/server/data/puppetserver/.puppetlabs/etc/puppet/ssl/certs/puppetdb.pem ]
then
    /opt/puppetlabs/server/bin/puppetdb ssl-setup -f
else
    echo "    *** SSL Certificates missing! ***"
fi
