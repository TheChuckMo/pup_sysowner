# Class: sysowner
#
# This module manages sysowner
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class sysowner (
  $enable           = true, # true | false | absent
  $system_owners    = [], # array of owners
  $system_groups    = [], # array of groups
  $system_note      = 'General Purpose Server', # free text to describe the server
  $support_level    = 'no-page', # free text to define support level
  # work-day | 24x7 | backup-only | no-page
  $support_contact  = 'ucat@ohsu.edu', # support contact email
  $fact_template    = "templates/system_owner.erb",
)
{
  if ! is_bool($enable) { fail("enable must be true/false") }
  if ! is_array($owners) and ! empty($owners) { fail("owners not a valid array")}
  if ! is_array($groups) and ! empty($groups) { fail("groups not a valid array")}  
  
}
