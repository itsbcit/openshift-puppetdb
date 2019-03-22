
if [ -w /etc/puppetlabs/puppetdb/conf.d/database.ini ];then
    sed -i -e "s|PUPPETDB_DATABASE_CONNECTION|${PUPPETDB_DATABASE_CONNECTION}|" /etc/puppetlabs/puppetdb/conf.d/database.ini
    sed -i -e "s/PUPPETDB_USER/${PUPPETDB_USER}/" /etc/puppetlabs/puppetdb/conf.d/database.ini
    sed -i -e "s/PUPPETDB_PASSWORD/${PUPPETDB_PASSWORD}/" /etc/puppetlabs/puppetdb/conf.d/database.ini
fi
