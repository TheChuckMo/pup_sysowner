require 'yaml'

data = YAML.load_file('/etc/sysowner/sysowner.yaml')

#puts data.inspect

config = {
    # owners
    #'system_owners'             =>  scope.lookupvar("sysowner::system_owners"),
    #'system_groups'             =>  scope.lookupvar("sysowner::system_groups"),
    # role and note
    #'system_role'               =>  scope.lookupvar("sysowner::system_role"),
    #'system_note'               =>  scope.lookupvar("sysowner::system_note"),
    # support info
    #'support_team'              =>  scope.lookupvar("sysowner::support_team"),
    #'support_level'             =>  scope.lookupvar("sysowner::support_level"),
    #'support_contact'           =>  scope.lookupvar("sysowner::support_contact"),
    #'support_pager'             =>  scope.lookupvar("sysowner::support_pager"),
    # clients
    'clients'                   => data['clients']
    # patch method
    #'patch_method'              =>  scope.lookupvar("sysowner::patch::method"),
    # cron facts
    #'cron_reboot'               =>  scope.lookupvar("sysowner::patch::cron_reboot"),
    #'cron_minute'               =>  scope.lookupvar("sysowner::patch::cron_minute"),
    #'cron_hour'                 =>  scope.lookupvar("sysowner::patch::cron_hour"),
    #'cron_monthday'             =>  scope.lookupvar("sysowner::patch::cron_monthday"),
    #'cron_month'                =>  scope.lookupvar("sysowner::patch::cron_month"),
    #'cron_weekday'              =>  scope.lookupvar("sysowner::patch::cron_weekday"),
    #'cron_script_src'           =>  scope.lookupvar("sysowner::patch::cron_script_src"),
    #'cron_script_dst'           =>  scope.lookupvar("sysowner::patch::cron_script_dst"),
    ## yum_cron facts
    #'yum_cron_apply_updates'    => scope.lookupvar("sysowner::patch::yum_cron_apply_updates"),
    #'yum_cron_download_updates' => scope.lookupvar("sysowner::patch::yum_cron_download_updates"),
    #'yum_cron_days_of_week'     => scope.lookupvar("sysowner::patch::yum_cron_days_of_week"),
    #'yum_cron_update_cmd'       => scope.lookupvar("sysowner::patch::yum_cron_update_cmd"),
    #'yum_cron_mailto'           => scope.lookupvar("sysowner::patch::yum_cron_mailto"),
    # config commands
    #'so_cmd'                    =>  scope.lookupvar("sysowner::config::so_cmd"),
    #'so_config'                 =>  scope.lookupvar("sysowner::config::so_config"),
    # python config
    #'so_python_install'         =>  scope.lookupvar("sysowner::config::python_install"),
    #'so_python_pkg'             =>  scope.lookupvar("sysowner::config::python_pkg"),
    #'so_python_yaml_pkg'        =>  scope.lookupvar("sysowner::config::python_yaml_pkg")
}

Facter.add(:clients) do
    setcode do
        clients = config['clients']
    end
end
        #clients.each do |client, value|
        #{client}_client: #{value}"
        #end