#
# sysowner
#
# Parametets
#
# sysowner::system_owners:
#  List of users and/or distribution lists of stake holders of the system.
#  - Will includes owners from node, role, and group.
#
# sysowner::system_type:
#   System configuration based on a type definition. Customization to the type is done in a role.
#   - A type allows a default config for a hosts primary job (oracle, mysql, etc)
#   - Class configuration is customized with a role
#   - examples: mysql-db, oracle-db, weblogic, nginx, apache
#
# sysowner::system_role:
#   A single defined purpose for the system. Based on the primary application running on the server.
#   - A role config will be included into the system configuration, including a list of system_owners
#   - Define needed system configuration to perform the role (kernel, limits, sudo, etc)
#   - examples: mysql-db-team, oracle-db-special, weblogic-secure, nginx-appname, apache
#
# sysowner::system_group:
#  A single group responsible for the delivery of the business services of the system.
#  - A group config will be included into the system configuration, primarily a list of system_owners
#  - Define group configuration needed by group administrators (banner logins, custom sudo, etc)
#  - examples: finance, webx, dw, clinics
#
# sysowner::system_note:
#  Free form string description of system.
#
class sysowner (
  #
  # owners of the system
  #
  $system_owners    = ['winklerh'],
  #
  # class: base host configuration - hiera: "roles/%{::system_class}"
  #
  $system_type      = 'common',
  #
  # role: customize class - hiera ex: "class/%{::system_class}"
  #
  $system_role      = 'general',
  #
  # group: Owner and user envrionment configuration
  #
  $system_group     = 'hwadmins',
  #
  # short description of server (define in role or node config)
  #
  $system_note      = 'General Purpose Server',
  #
  # set fact for system authentication and authorization
  #
  $auth_methods     = ['local', 'centrify'],
  $system_auth      = 'local',
  #
  # Support information for system
  #
  $support_team     = 'unix team',
  $support_level    = 'no-page',
  $support_pager    = 'unix-oncall',
  $support_contact  = 'root@localhost',
  #
) {

  # verify system_owners
  validate_array($system_owners)

  # verify system_type
  validate_string($system_type)

  # verify system_role
  validate_string($system_role)

  # verify system_group
  validate_string($system_group)

  # verify system_note
  validate_string($system_note)

  # verify auth_methods
  validate_array($auth_methods)

  # verify system_auth
  validate_string($system_auth)
  if ! ($system_auth in $auth_methods) {
    fail("invalid method: ${system_auth}")
  }

  # build sysowner config
  include sysowner::config

}