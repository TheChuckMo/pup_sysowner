#
# sysowner patch facts
#
config = '/etc/sysowner/sysowner.yaml'
if File.file?(config)
    #
    # we have a file!
    #
    require 'yaml'
    #
    # import the config file
    #
    raw = YAML.load_file(config)
    #
    # Clean up the data - only show the facts we need
    #
    if raw['patch_method'] == 'cron'
        data = {
            # patch method - cron
            'patch_method'                      => raw['patch_method'],
            # cron facts
            'patch_cron_reboot'                 => raw['cron_reboot'],
            'patch_cron_weekday'                => raw['cron_weekday'],
            'patch_cron_script'                 => raw['cron_script_dst']
        }
    elsif raw['patch_method'] == 'yum_crom'
        data = {
            # patch method - yum_cron
            'patch_method'                      => raw['patch_method'],
            # yum_cron facts
            'patch_yum_cron_apply_updates'      => raw['yum_cron_apply_updates'],
            'patch_yum_cron_update_cmd'         => raw['yum_cron_update_cmd']
        }
    else
        #
        # this should be "disable" - should it be forced?
        #
        data = { 'patch_method'                 => raw['patch_method'] }
    end
    #
    # load all the patch facts
    #
    data.each do |name, value|
        #value = data[name]
        Facter.add(name) do
            setcode do
                answer = value
            end
        end
    end

else
    #
    # no facts yet
    #
    Facter.add(:sysowner_patch) do
        setcode do
            answer = 'no-facts'
        end
    end
end
