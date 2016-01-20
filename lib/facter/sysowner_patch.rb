#
# sysowner patch facts
require 'yaml'

if File.file?(config)
    raw = YAML.load_file('/etc/sysowner/sysowner.yaml')

    if raw['patch_method'] == 'cron'
        data = {
            # patch method
            'patch_method'                      => raw['patch_method'],
            # cron facts
            'patch_cron_reboot'                 => raw['cron_reboot'],
            'patch_cron_minute'                 => raw['cron_minute'],
            'patch_cron_hour'                   => raw['cron_hour'],
            'patch_cron_monthday'               => raw['cron_monthday'],
            'patch_cron_month'                  => raw['cron_month'],
            'patch_cron_weekday'                => raw['cron_weekday'],
            'patch_cron_script_src'             => raw['cron_script_src'],
            'patch_cron_script_dst'             => raw['cron_script_dst'],
        }
    elsif raw['patch_method'] == 'yum_crom'
        data = {
            # patch method
            'patch_method'                      => raw['patch_method'],
            # yum_cron facts
            'patch_yum_cron_apply_updates'      => raw['yum_cron_apply_updates'],
            'patch_yum_cron_download_updates'   => raw['yum_cron_download_updates'],
            'patch_yum_cron_days_of_week'       => raw['yum_cron_days_of_week'],
            'patch_yum_cron_update_cmd'         => raw['yum_cron_update_cmd'],
            'patch_yum_cron_mailto'             => raw['yum_cron_mailto']
        }
    else
        data = { 'patch_method'                      => raw['patch_method'] }
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
