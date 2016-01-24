#
# sysowner
#
class sysowner (
    #
    # owners of the system
    #
    $system_owners = ['Henry Winkler',], # array of owners
    $system_groups = ['AD HW Fans',], # array of groups
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
    validate_array($system_groups)

    # include patch control
    include sysowner::patch

    # include sysowner configuration - fact setup
    include sysowner::config
}