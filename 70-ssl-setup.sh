if [ -r /etc/puppetlabs/puppetdb/ssl/ca.pem ] && \
   [ -r /etc/puppetlabs/puppetdb/ssl/private.pem ] && \
   [ -r /etc/puppetlabs/puppetdb/ssl/public.pem ]; then
    echo "    *** Found existing SSL files ***"
else
    echo "    *** PuppetDB SSL files not found ***"

    if [ -r /etc/puppetlabs/puppet/ssl/certs/ca.pem ] && \
       [ -r /etc/puppetlabs/puppet/ssl/signed/${PUPPET_CERTNAME}.pem ] && \
       [ -r /etc/puppetlabs/puppet/ssl/private_keys/${PUPPET_CERTNAME}.pem ];then
        echo "    *** Copying SSL files from puppetserver ***"
    else
        echo "    *** Attempting PuppetDB ssl-setup ***"
        /opt/puppetlabs/server/bin/puppetdb ssl-setup
    fi
fi
