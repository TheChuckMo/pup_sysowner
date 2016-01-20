#
# sysowner core facts
#
require 'yaml'

raw = YAML.load_file('/etc/sysowner/sysowner.yaml')

data = {
    # owners
    'system_owners'                     => raw['system_owners'],
    'system_groups'                     => raw['system_groups'],
    # role and note
    'system_role'                       => raw['system_role'],
    'system_note'                       => raw['system_note'],
    # support info
    'support_team'                      => raw['support_team'],
    'support_level'                     => raw['support_level'],
    'support_contact'                   => raw['support_contract'],
    'support_pager'                     => raw['support_pager'],
    # clients
    'clients'                           => raw['clients'],
    'flat_facts'                        => raw['flat_facts'],
}
#
# load all the facts
#
data.each do |name, value|
    #value = data[name]
    Facter.add(name) do
        setcode do
            answer = value
        end
    end
end
#
# clients facts
#
Facter.add(:clients) do
    setcode do
        clients = data['clients']
    end
end
#
# build clients facts
#
data['clients'].each_with_index do |client, idx|
    name = "clients_#{client}"
    Facter.add(name) do
        setcode do
            answer = raw['clients'][client]
        end
    end
end

#
# system_owners & groups
#
if data['flat_facts']
    data['system_owners'].each_with_index do |owner, idx|
        name = "system_owners_#{idx}"
        Facter.add(name) do
            setcode do
                answer = owner
            end
        end
    end

    data['system_groups'].each_with_index do |group, idx|
        name = "system_groups_#{idx}"
        Facter.add(name) do
            setcode do
                answer = group
            end
        end
    end
else
    Facter.add(:system_owners) do
        setcode do
            answer = data['system_owners']
        end
    end

    Facter.add(:system_groups) do
        setcode do
            answer  = data['system_groups']
        end
    end
end
