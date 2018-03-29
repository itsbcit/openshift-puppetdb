if [ "$RUNUSER" = "puppetdb" ];then
    sed -i "s/puppetdb:x:998:997/puppetdb:x:${UID}:0/" /etc/passwd
    sed -i "s/puppetdb:x:997:/puppetdb:x:997:puppetdb/" /etc/group

    pgroup=`id -g -n`
    sed -i "s/GROUP=%/GROUP=$pgroup/" /etc/sysconfig/puppetdb
fi
