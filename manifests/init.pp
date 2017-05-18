#
# sysowner
#
# Parametets
#
# sysowner::system_owners:
#  List of users and/or distribution lists of stake holders of the system.
#  - Will includes owners from node, role, and group.
#
# sysowner::system_class:
#   System configuration based on a class definition. Customization to the class is done in a role.
#   - A class allows a default config for a hosts primary job (oracle, mysql, etc)
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
  $system_owners    = $sysowner::params::system_owners,
  #
  # class: base host configuration - hiera: "roles/%{::system_class}"
  #
  $system_class      = $sysowner::params::system_class,
  #
  # role: customize class - hiera ex: "class/%{::system_class}"
  #
  $system_role      = $sysowner::params::system_role,
  #
  # group: Owner and user envrionment configuration
  #
  $system_group     = $sysowner::params::system_group,
  #
  # short description of server (define in role or node config)
  #
  $system_note      = $sysowner::params::system_note,
  #
  # set fact for system authentication and authorization
  #
  $system_auth      = $sysowner::params::system_auth,
  #
  # Support information for system
  #
  $support_team     = $sysowner::params::support_team,
  $support_level    = $sysowner::params::support_level,
  $support_pager    = $sysowner::params::support_pager,
  $support_contact  = $sysowner::params::support_contact,
  #
  # Control patching control (deprecating support)
  #
  $manage_yum_cron = true,
  #
) inherits sysowner::params {

  # verify system_owners
  validate_array($system_owners)

  # verify system_groups
  validate_string($system_group)

  include sysowner::config

  if $manage_yum_cron {
    # include patch control
    include sysowner::patch
  }

}