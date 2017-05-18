#==class: sysowner::params
class sysowner::params () {
  #
  # owners of the system
  #
  $system_owners    = ['winklerh']
  #
  # class: base host configuration - hiera: "roles/%{::system_class}"
  #
  $system_class      = 'common'
  #
  # role: customize class - hiera ex: "roles/%{::system_role}"
  #
  $system_role      = 'general'
  #
  # group: Owner and user envrionment configuration
  #
  $system_group     = 'hwadmins'
  #
  # short description of server (define in role or node config)
  #
  $system_note      = 'General Purpose Server'
  #
  # set fact for system authentication and authorization
  #
  $system_auth      = 'local'
  #
  # Support information for system
  #
  $support_team     = 'unix team'
  $support_level    = 'no-page'
  $support_pager    = 'unix-oncall'
  $support_contact  = 'root@localhost'
}