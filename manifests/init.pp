# Class: sysowner
#
# See README.md for info
#
class sysowner (
  # Basic system info
  $system_owners    = [], # array of owners
  $system_groups    = [], # array of groups
  $system_role      = 'general', # system role - general | web | mysql | oracle | etl | epic
  $system_oraclient = false, # will oracle client be installed
  $system_note      = 'General Purpose Server', # free text to describe the server
  # Support information for system
  $support_team     = 'UCAT', # free text of support team name
  $support_level    = 'no-page', # work-day | 24x7 | backup-only | no-page
  $support_contact  = 'ucat@ohsu.edu', # support contact email
  $support_qpage    = 'unix_oncall', # support qpage contact
  # module behavior control
  $fact_template    = "sysowner/system_owner_facts.epp", # EPP template for fact file
  $fact_file        = "/etc/facter/facts.d/system_owner_facts.yaml", # location of fact file on system
  # Python control
  # TODO: will write yaml for facts instead - no python needed now!
  $python_install   = false, # should the module install python
  $python_pkg       = "python", # name of package with python
  $python_yaml_pkg  = "PyYAML", # name of package with python PyYAML module
  # Patch details for system
  # TODO: patch control will come in v2 - ignore for now
  # TODO: too much choice for patch install - maybe: monthly, quarterly, yearly
  $patch_control    = false, # should sysowner manage patch installs
  $patch_reboot     = true, # should system reboot after patch install
  $patch_hour       = '3', # hour of the day for patch install
  $patch_minute     = '0', # minute of the hour for patch install
  $patch_weekday    = '1', # day of week for patch install
  $patch_month      = '3,6,9,13', # month of the year for patch install
  $patch_monthday   = '15', # day of month for patch install
  $patch_script_src = 'files/sysowner_patch_install.sh', # cron script source for patch install
  $patch_script_dst = '/usr/local/bin/sysowner_patch_install.sh', # cron script destination for patch install
)
{
  # variable verification
  if ! is_array($system_owners) and ! empty($system_owners) { fail("system owners not a valid array.")}
  if ! is_array($system_groups) and ! empty($system_groups) { fail("system groups not a valid array.")}
  if ! is_string($system_note) { fail("system note not a valid string.")}

  # are we managing python install?
  if $python_install {
    package { 'python':
      name => $python_pkg,
      ensure => installed,
    }
    package { 'python-yaml':
      name => $python_yaml_pkg,
      ensure => installed,
      require => Package['python'],
    }
  }

  file { "$fact_file":
    ensure => file,
    content => epp($fact_template),
  }
  
}
