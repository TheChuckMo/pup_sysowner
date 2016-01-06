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
  $oracle_client = false, # configure for oracle client install
  # user in hiera ex: "oraclient_%{::sysowner:oracle_client}" => oraclient_true.yaml
  # module behavior control
  $fact_template    = 'sysowner/system_owner_facts.erb', # ERB template for fact file
  $fact_file        = '/etc/facter/facts.d/system_owner_facts.yaml', # location of fact file on system
  # Patch details for system
  $patch_method     = 'disable', # how to patch - yum_cron | cron
  # disable: do nothing *default*
  # cron: runs script from cron
  # yum_cron: uses treydock/yum-cron module to configure yum_cron
  # cron variables
  $patch_reboot     = false, # should system reboot after patch install
  $patch_minute     = '45', # minute of the hour for patch install
  $patch_hour       = '3', # hour of the day for patch install
  $patch_monthday   = '15', # day of month for patch install
  $patch_month      = '*', # month of the year for patch install
  $patch_weekday    = '1', # day of week for patch install
  $patch_script_src = 'puppet:///modules/sysowner/sysowner_patch_install.sh', # cron script source for patch install
  $patch_script_dst = '/usr/local/bin/sysowner_patch_install.sh', # cron script destination for patch install
  # yum-cron variables
  $patch_apply_updates    = false, # will apply updates after download
  $patch_download_updates = true, # must me true if apply_updates true
  $patch_days_of_week     = '12345', # only check on work-days
  $patch_update_cmd      = 'minimal-security', # only valid for =>EL7
  # default                            = yum upgrade
  # security                           = yum --security upgrade
  # security-severity:Critical         = yum --sec-severity=Critical upgrade
  # minimal                            = yum --bugfix upgrade-minimal
  # minimal-security                   = yum --security upgrade-minimal
  # minimal-security-severity:Critical =  --sec-severity=Critical upgrade-minimal
)
{

  # verify system_owners and system_groups
  validate_array($system_owners)
  validate_array($system_groups)

  # verify oracle_client boolean
  validate_bool($oracle_client)

  # verify support patch method
  validate_re($patch_method, [ '^disable', '^cron', '^yum_cron'])

  # ensure facter directory exists
  file { '/etc/facter': ensure => 'directory', replace => 'no', }
  file { '/etc/facter/facts.d': ensure => 'directory', replace => 'no', }

  # fact file for system
  file { $fact_file:
    ensure  => file,
    content => template($fact_template),
    owner   => 'root',
    group   => 'puppet',
    mode    => '0644',
  }

  # define patch_method settings
  case $patch_method {
    'yum_cron': {
      # settings for yum_cron
      $patch_script_ensure = 'absent'
      $cron_entry_ensure = 'absent'
      $yum_cron_ensure = 'present'
      $yum_cron_enable = true
    }
    'cron': {
      # settings for cron
      $patch_script_ensure = 'file'
      $cron_entry_ensure = 'present'
      $yum_cron_ensure = 'absent'
      $yum_cron_enable = false

    }
    'disable': {
      # settings for disable
      $patch_script_ensure = 'absent'
      $cron_entry_ensure = 'absent'
      $yum_cron_ensure = 'absent'
      $yum_cron_enable = false
    }
    default: {
      # disable it all
      $patch_script_ensure = 'absent'
      $cron_entry_ensure = 'absent'
      $yum_cron_ensure = 'absent'
      $yum_cron_enable = false
    }
  }

  # patch script configuration
  file { $patch_script_dst:
    ensure  => $patch_script_ensure,
    source  => $patch_script_src,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  # patch script cron entry
  cron { 'syswoner-patch-install':
    ensure    => $cron_entry_ensure,
    command   => "${patch_script_dst} 2>&1 >/dev/null",
    user      => 'root',
    minute    => $patch_minute,
    hour      => $patch_hour,
    monthday  => $patch_monthday,
    month     => $patch_month,
    weekday   => $patch_weekday,
  }

  # configure yum_cron
  class { 'yum_cron':
    ensure => $yum_cron_ensure,
    enable => $yum_cron_enable,
    mailto => $support_contact,

    apply_updates => $patch_apply_updates,
    download_updates => $patch_download_updates,
    days_of_week => $patch_days_of_week,
    update_cmd => $patch_update_cmd,
  }
}