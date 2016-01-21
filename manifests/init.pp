#
# See README.md for info
#
class sysowner (
    #
    # owners of the system
    #
    $system_owners = ['Henry Winkler',], # array of owners
    $system_groups = ['AD HW Fans',], # array of groups
    #
    # role: one per system - in hiera ex: "roles/%{::system_role}" => roles/web.yaml
    #
    $system_role = 'general', # system role - general | web | mysql | oracle | etl | epic
    #
    # general description of server (define in role on node yaml)
    #
    $system_note = 'General Purpose Server', # free text to describe the server
    #
    # Support information for system
    #
    $support_team = 'unix team', # free text of support team name
    $support_level = 'no-page', # work-day | 24x7 | backup-only | no-page
    $support_contact = 'root@localhost', # support contact email
    $support_pager = 'unix-oncall', # support contact pager
    #
    # clients: many per server - requirements per client [oracle, mysql, monitoring]
    # user in hiera ex: "oraclient_%{::sysowner:oracle_client}" => oraclient_true.yaml
    #
    $clients = { 'oracle' => false, }, # client facts to create ex: oracle_client = true
) {
    # verify system_owners and system_groups
    validate_array($system_owners)
    validate_array($system_groups)

    # verify valid hash for clietns
    validate_hash($clients)

    # TODO: validate the clients hash values are boolean?
    # I don't know how to do this.
    # validate_bool_in_hash($clients)? what?

    # include patch control
    include sysowner::patch

    # include sysowner configuration - fact setup
    include sysowner::config
}