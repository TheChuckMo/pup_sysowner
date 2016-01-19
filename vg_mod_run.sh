#!/usr/bin/env bash

puppet='/opt/puppetlabs/bin/puppet'
builds='/vagrant'
modules='/etc/puppetlabs/code/environments/production/modules'
name='sysowner'

modtest="${builds}/tests/init.pp"
if [[ -f ${modtest} ]] ;then
    sudo $puppet apply ${modtest} $@
fi