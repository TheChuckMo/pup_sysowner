# Class: sysowner
#
# See README.md for info
#
class sysowner (
  # Basic system info
  $system_owners    = ['Henry Winkler',], # array of owners
  $system_groups    = ['AD HW Fans',], # array of groups
  $system_role      = 'general', # system role - general | web | mysql | oracle | etl | epic
  # used in hiera ex: "roles/%{::sysowner:system_role}" => roles/web.yaml
  $system_note      = 'General Purpose Server', # free text to describe the server
  # Support information for system
  $support_team     = 'unix team', # free text of support team name
  $support_level    = 'no-page', # work-day | 24x7 | backup-only | no-page
  $support_contact  = 'root@localhost', # support contact email
  $support_pager    = 'unix-team', # support contact pager

  # Optional parameters (one-off custom configs)
  # user in hiera ex: "oraclient_%{::sysowner:oracle_client}" => oraclient_true.yaml
  $oracle_client    = false, # configure for oracle client install
  $clients          = { 'oracle' => false, }, # client facts to create ex: oracle_client = true

  # Control of fact file
  $fact_template    = 'sysowner/system_owner_facts.erb', # ERB template for fact file
  $fact_file        = '/etc/facter/facts.d/system_owner_facts.yaml', # location of fact file on system
  $fact_flat        = false, # sysowner1 or sysowner[1]
  #
) {
  # verify system_owners and system_groups
  validate_array($system_owners)
  validate_array($system_groups)

  # verify valid hash for clietns
  #validate_array($clients)
  validate_hash($clients)

  # verify oracle_client boolean
  validate_bool($oracle_client)

  # verify flat fact is bool
  validate_bool($fact_flat)

  # include patch control
  include sysowner::patch

  # base directory of fact file locaiton
  $basedir = dirname($fact_file)

  # exec to create basedir
  exec { 'make_basedir':
    command => "/bin/mkdir -p ${basedir}",
    unless  => "/bin/ls -d ${basedir}",
  }

  # fact file for system
  file { $fact_file:
    ensure  => file,
    content => template($fact_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Exec['make_basedir'],
  }
}