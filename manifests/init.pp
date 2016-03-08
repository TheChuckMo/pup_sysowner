#
# sysowner
#
# Parametets
#
# sysowner::system_owners:
#  List of users and/or distribution lists of stake holders of the system.
#  - Will includes owners from node, role, and group.
#
# sysowner::system_role:
#  A single defined purpose for the system. Based on the primary application running on the server.
#  - A role config will be included into the system configuration, including a list of system_owners
#  - Define needed system configuration to perform the role (kernel, limits, sudo, etc)
#  - examples: mysql-db, oracle-db, weblogic, nginx, apache
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
    $system_owners = ['winklerh'], # array of owners
    #
    # group/team owner of system
    #
    $system_group = 'hwadmins', # string of group
    #
    # role: one per system - in hiera ex: "roles/%{::system_role}" => roles/webproxy.yaml
    #
    $system_role = 'general', # system role - general | web | mydb | oradb | epic | nosql
    #
    # short description of server (define in role or node config)
    #
    $system_note = 'General Purpose Server', # free text to describe the server
    #
    # Support information for system
    #
    $support_team = 'unix team', # free text of support team name
    $support_level = 'no-page', # work-day | 24x7 | backup-only | no-page
    $support_pager = 'unix-oncall', # support contact pager
    $support_contact = 'root@localhost', # support contact email
) {
    # verify system_owners
    validate_array($system_owners)

    # verify system_groups
    validate_string($system_group)

    # include patch control
    include sysowner::patch

    # include sysowner configuration - fact setup
    include sysowner::config
}