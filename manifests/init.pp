# Class: sysowner
#
# Manage system owners and roles with fact files on system
#
# Parameters:
#
# System parameters:
# system_owners: array of system owner names (should be valid accounts on system)
# system_groups: array of system groups (group on server not required)
# system_note: short description of server usage
#
# Support parameters:
# support_team: name of OS/Hardware team supporting the system
# support_contact: email contact of support team
# support_level: level of support for system defaults(no-page, work-day, backup-only, 24x7)
#
# Module behavior parameters:
# fact_template: ERB template to use for writing facts
# fact_file: file location of custom facts
# python_install: true or false: install python and PyYAML
# python_pkg: name of python (rpm/yum) package for install
# python_yaml_pky: name of python module (rpm/yum) package for install
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class sysowner (
  # Basic system info
  $system_owners    = [], # array of owners
  $system_groups    = [], # array of groups
  $system_note      = 'General Purpose Server', # free text to describe the server
  # Support information for system
  $support_team     = 'UCAT', # free text of support team name
  $support_level    = 'no-page', # work-day | 24x7 | backup-only | no-page
  $support_contact  = 'ucat@ohsu.edu', # support contact email
  $support_qpage    = 'unix_oncall', # support qpage contact
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
  # module behavior control
  $fact_template    = "templates/system_owner.erb", # template for fact file
  $fact_file        = "/etc/facter/facts.d/system_owner.yaml", # location of fact file on system
  $python_install   = true, # should the module install python
  $python_pkg       = "python", # name of package with python
  $python_yaml_pkg  = "PyYAML", # name of package with python PyYAML module
)
{
  # variable verification
  if ! is_array($system_owners) and ! empty($system_owners) { fail("system owners not a valid array.")}
  if ! is_array($system_groups) and ! empty($system_groups) { fail("system groups not a valid array.")}
  if ! is_string($system_note) { fail("system note not a valid string.")}


  
}
