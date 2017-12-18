#
# sysowner::config
#
class sysowner::config (
    #
    # command configuration
    #
    $so_cmd           = '/usr/local/bin/sysowner',
    #
    # python control
    #
    $python_install   = true, # should the module install python
    $python_pkg       = "python", # name of package with python
    $python_yaml_pkg  = "PyYAML", # name of package with python PyYAML module
) {
    # verify boolean values
    validate_bool($python_install)

    # are we managing python install?
    if $python_install {
        # install python
        ensure_packages($python_pkg, {ensure => 'present'})
        # install yaml
        ensure_packages($python_yaml_pkg, {ensure => 'present'})

        #package { 'python':
        #    name   => $python_pkg,
        #    ensure => installed,
        #}
        # install yaml python module
        #package { 'python-yaml':
        #    name    => $python_yaml_pkg,
        #    ensure  => installed,
        #    require => Package['python'],
        #}
    }

    # base directory of fact file locaiton
    $bindir = dirname($so_cmd)

    # exec to create basedir
    exec { 'make_bindir':
        command => "/bin/mkdir -p ${bindir}",
        unless  => "/bin/ls -d ${bindir}",
    }

    # sysowner python script
    file { $so_cmd:
        ensure  => file,
        source  => 'puppet:///modules/sysowner/sysowner.py',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        require => Exec['make_bindir']
    }

    # static location of config file
    $so_config = '/etc/sysowner/sysowner.yaml'

    # base directory of fact file locaiton
    $basedir = dirname($so_config)

    # exec to create basedir
    exec { 'make_basedir':
        command => "/bin/mkdir -p ${basedir}",
        unless  => "/bin/ls -d ${basedir}",
    }

    # config file for sysowner - for facts
    file { $so_config:
        ensure  => file,
        content => template('sysowner/sysowner.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Exec['make_basedir'],
    }
}