# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Define Box
  config.vm.define "rhel7" do |rhel7|
    rhel7.vm.box_url = "http://uxtools.ohsu.edu/vagrant/uxrhel73.json"
    rhel7.vm.box = "ux/uxrhel73"
    rhel7.vm.hostname = "rhel7"
  end

  config.vm.define "rhel6" do |rhel6|
    rhel6.vm.box_url = "http://uxtools.ohsu.edu/vagrant/uxrhel69.json"
    rhel6.vm.box = "ux/uxrhel69"
    rhel6.vm.hostname = "rhel69"
  end

  # Subscription-Manager
  if Vagrant.has_plugin?('vagrant-registration')
    # Don't register
    #config.registration.skip  = true
    #
    # Register with Satellite server
    config.registration.serverurl = "https://ucatlx01.ohsu.edu:443/rhsm"
    config.registration.baseurl = "https://ucatlx01.ohsu.edu/pulp/repos"
    config.registration.org = "UCAT"
    config.registration.activationkey = "act-lab-rhel73-base"
    #
    # Register with Red Hat directly
    # EPEL NOT availble directly from Red Hat
    #config.registration.serverurl = "https://subscription.rhsm.redhat.com:443/subscription"
    #config.registration.baseurl = "https://cdn.redhat.com"
    #config.registration.org = "******"
    #config.registration.activationkey = "act******"
  end

  config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 2182, host: 2182, host_ip: "127.0.0.1"

  config.vm.provision "shell", inline: 'yum clean all'

  config.vm.provision "puppet" do |puppet|
    puppet.facter = {
      "vagrant" => "1"
    }
    puppet.hiera_config_path = "puppet/hiera.yaml"
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "site.pp"
    puppet.module_path = "puppet/modules"
  end

  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
end

