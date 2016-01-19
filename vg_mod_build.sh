#!/bin/bash


puppet='/opt/puppetlabs/bin/puppet'
builds='/vagrant'
modules='/etc/puppetlabs/code/environments/production/modules'
name='sysowner'

modpath="${modules}/${name}"
if [[ -d ${modpath} ]] ;then
    echo "removing existing ${name}"
    sudo rm -Rf ${modpath}
fi

if [[ -d ${builds} ]] ;then
    echo "building new module"
    module=`sudo $puppet module build ${builds} | grep "built:" | awk '{print $3}'`
    echo "${module} - built"
fi

if [[ -f ${module} ]] ;then
    echo "installing module"
    sudo $puppet module install ${module}
fi


