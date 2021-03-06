#
# sysowner core facts
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
    data = {
        # system owners
        'system_owners'                     => raw['system_owners'],
        # system type
        'system_type'                       => raw['system_type'],
        # system group
        'system_group'                      => raw['system_group'],
        # system role
        'system_role'                       => raw['system_role'],
        # system note
        'system_note'                       => raw['system_note'],
        # system auth
        'system_auth'                       => raw['system_auth'],
        # patch & reboot group
        'patch_group'                       => raw['patch_group'],
        'reboot_group'                      => raw['reboot_group'],
        # support info
        'support_team'                      => raw['support_team'],
        'support_level'                     => raw['support_level'],
        'support_contact'                   => raw['support_contract'],
        'support_pager'                     => raw['support_pager'],
    }
    #
    # flat system_owners
    #
    data['system_owners'].each_with_index do |owner, idx|
        name = "system_owners_#{idx}"
        data[name] = owner
    end
    #
    # load the facts
    #
    data.each do |name, value|
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
    Facter.add(:sysowner_core) do
        setcode do
            answer = 'no-facts'
        end
    end
end
