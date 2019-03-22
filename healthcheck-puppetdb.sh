#!/bin/bash

/opt/puppetlabs/puppet/bin/curl \
    --fail -H 'Accept: pson' \
    http://127.0.0.1:8080/status/v1/services/puppetdb-status |grep -q '"state":"running"'
