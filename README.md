# Class: sysowner

 Manage system owners and groups, system role, and patch updating. 

## Parameters: 

### Basic system info
  - system_owners: free form array of "system owners", could be emails, local account, names
  - system_groups: free form array of "system owner groups", AD groups, local unix groups, team names
  - system_role: free form string. ex: general | web | mysql | oracle | etl | epic
    - use in hiera. ex: "roles/%{::sysowner:system_role}" => roles/web.yaml
  - system_note: free form string to describe the server
  
```
sysowner::system_owners: 
  - Henry Winkler
sysowner::system_groups:
   - AD HW Fan
sysowner::system_role: 'general'
sysowner::system_note: 'General Purpose Server'
```

### Support information for system
  - support_team: free form string for support team name
  - support_level: free form string of support level
  - support_contact: support contact email

```
sysowner::support_team: 'unix team'
sysowner::support_level: 'no-page'
sysowner::support_contact: 'root@localhost'
```

### Optional parameters (one-off custom configs)
  - oracle_client: configure for oracle client install
    - use in hiera ex: "oraclient_%{::sysowner:oracle_client}" => oraclient_true.yaml
  
```
sysowner::oracle_client = false
```

### Patch methods - disable | cron | yum_cron
#### disable 
```
sysowner::patch_method: 'disable'
```
#### cron *defaults*
```
sysowner::patch_method:     'cron'
sysowner::patch_reboot:     false, 
sysowner::patch_minute:     '45'
sysowner::patch_hour:       '3'
sysowner::patch_monthday:   '15'
sysowner::patch_month:      '*'
sysowner::patch_weekday:    '1'
sysowner::patch_script_src: 'puppet:///modules/sysowner/sysowner_patch_install.sh'
sysowner::patch_script_dst: '/usr/local/bin/sysowner_patch_install.sh'
```
#### yum_cron *defaults*
```
sysowner::patch_method:     'yum_cron'
sysowner::patch_apply_updates:      false
sysowner::patch_download_updates:   true
sysowner::patch_days_of_week:       '12345'
sysowner::patch_update_cmd:        'minimal-security'
```
##### sysowner::patch_update_cmd
  - default                            = yum upgrade
  - security                           = yum --security upgrade
  - security-severity:Critical         = yum --sec-severity=Critical upgrade
  - minimal                            = yum --bugfix upgrade-minimal
  - *minimal-security*                   = yum --security upgrade-minimal
  - minimal-security-severity:Critical =  --sec-severity=Critical upgrade-minimal

## Facts Created
```
system_groups => ["AD HW Fans"]
system_note => General Purpose Server
system_owners => ["Henry Winkler"]
system_role => general
support_contact => root@localhost
support_level => no-page
support_team => unix team
```
### patch_method: disable 
```patch_method => disable```
### patch_method: cron
```
patch_method => cron
patch_cron => 45 3 15 * 1
patch_script => /usr/local/bin/sysowner_patch_install.sh
```
### patch_method: yum-cron
```
patch_days_of_week => 12345
patch_download_updates => true
patch_method => yum_cron
patch_update_cmd => minimal-security
```

## Requires

  - [treydock/yum_cron](https://forge.puppetlabs.com/treydock/yum_cron)
  - [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
