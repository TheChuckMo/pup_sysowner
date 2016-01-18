class sysowner::patch (
    # Patch details for system
    $method     = 'disable', # how to patch - yum_cron | cron
    # disable: do nothing *default*
    # cron: runs script from cron
    # yum_cron: uses treydock/yum-cron module to configure yum_cron

    # cron variables
    $cron_reboot     = 'false', # should system reboot after patch install
    $cron_minute     = '45', # minute of the hour for patch install
    $cron_hour       = '3', # hour of the day for patch install
    $cron_monthday   = '15', # day of month for patch install
    $cron_month      = '*', # month of the year for patch install
    $cron_weekday    = '1', # day of week for patch install
    $cron_script_src = 'puppet:///modules/sysowner/sysowner_patch_install.sh', # cron script source for patch install
    $cron_script_dst = '/usr/local/bin/sysowner_patch_install.sh', # cron script destination for patch install
    # yum-cron variables
    $yum_cron_apply_updates    = false, # will apply updates after download
    $yum_cron_download_updates = true, # must me true if apply_updates true
    $yum_cron_days_of_week     = '12345', # only check on work-days
    $yum_cron_update_cmd      = 'minimal-security', # only valid for =>EL7
    $yum_cron_mailto            = $sysowner::support_contact,
    # default                            = yum upgrade
    # security                           = yum --security upgrade
    # security-severity:Critical         = yum --sec-severity=Critical upgrade
    # minimal                            = yum --bugfix upgrade-minimal
    # minimal-security                   = yum --security upgrade-minimal
    # minimal-security-severity:Critical =  --sec-severity=Critical upgrade-minimal
) {

    # verify support patch method
    validate_re($method, [ '^disable', '^cron', '^yum_cron'])

    # define patch_method settings
    case $method {
        'yum_cron': {
            # settings for yum_cron
            $patch_script_ensure = 'absent'
            $cron_entry_ensure = 'absent'
            $yum_cron_ensure = 'present'
            $yum_cron_enable = true
        }
        'cron': {
            # settings for cron
            $patch_script_ensure = 'file'
            $cron_entry_ensure = 'present'
            $yum_cron_ensure = 'absent'
            $yum_cron_enable = false

        }
        'disable': {
            # settings for disable
            $patch_script_ensure = 'absent'
            $cron_entry_ensure = 'absent'
            $yum_cron_ensure = 'absent'
            $yum_cron_enable = false
        }
        default: {
            # disable it all
            $patch_script_ensure = 'absent'
            $cron_entry_ensure = 'absent'
            $yum_cron_ensure = 'absent'
            $yum_cron_enable = false
        }
    }

    # patch script configuration
    file { $cron_script_dst:
        ensure  => $patch_script_ensure,
        source  => $cron_script_src,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    # patch script cron entry
    cron { 'syswoner-patch-install':
        ensure    => $cron_entry_ensure,
        command   => "${cron_script_dst} reboot=${cron_reboot} 2>&1 >/dev/null",
        user      => 'root',
        minute    => $cron_minute,
        hour      => $cron_hour,
        monthday  => $cron_monthday,
        month     => $cron_month,
        weekday   => $cron_weekday,
    }

    # configure yum_cron
    class { 'yum_cron':
        ensure => $yum_cron_ensure,
        enable => $yum_cron_enable,
        mailto => $yum_cron_mailto,

        apply_updates => $yum_cron_apply_updates,
        download_updates => $yum_cron_download_updates,
        days_of_week => $yum_cron_days_of_week,
        update_cmd => $yum_cron_update_cmd,
    }
}