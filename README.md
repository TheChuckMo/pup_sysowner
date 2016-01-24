# Class: sysowner

Create facts to be used for system management like owner of systems services and method of patching. Assigning a role allows configuration to be grouped. 

  - system_owners: Contact id for users who are responsible for the services provided by the system. 
  - system_groups: External security groups for the system or
  - system_role: Used to define configuration for a collection of systems. 
  - system_note: Short description of usage of server. 
  
### ex: in code 
```
case $sysowner::system_role {
  'web':                { include apache::config } # apply web apache web config 
  'db$':                { include dba::users  } # apply dba admin users and profiles
  'mydb':               { include dba::mydb  } # apply mysql database config
  default:              { include admin::generic } # apply the generic class
}
```
### ex: in heira
```
# /etc/hiera.yaml
:datadir:
    - nodes/%{::fqdn}
    - roles/%{::system_role}
# ./nodes/node.local.yaml
sysowner::system_role: 'mydb'
# ./roles/mydb.yaml
sysowner::system_owners:
    - myadmin1
    - myadmin1
sysowner::system_groups:
    - "MySQL Admins"
sysowner::system_note: 'MySQL Database Server'

classes:
    - dba:users
    - dba:mydb
```
## Parameters: 

### Basic system info
  - system_owners: free form array of "system owners", could be emails, local account, names
  - system_groups: free form array of "system owner groups", AD groups, local unix groups, team names
  - system_role: free form string. ex: general | web | mysql | oracle | etl | epic
    * use in hiera. ex: "roles/%{::system_role}" => roles/web.yaml
  - system_note: free form string to describe the server
  
```
sysowner::system_owners: 
  - Henry Winkler
sysowner::system_groups:
   - AD HW Fans
sysowner::system_role:  'general'
sysowner::system_note:  'General Purpose Server'
```

### Support information for system
  - support_team: free form string for support team name
  - support_level: free form string of support level
  - support_contact: support contact email

```
sysowner::support_team:     'unix team'
sysowner::support_level:    'no-page'
sysowner::support_contact:  'root@localhost'
```
### Patch methods - disable | cron | yum_cron
  Control the method of patching. 
  - disable: Will remove script or yum_cron configuration 
  - cron: Push out a custom script (you write) and create a cron entry to run script. 
  - yum_cron: Use the yum_cron tool to schedule patching and set installed patch level.
    *uses Puppet module: [treydock/yum_cron::update_cmd](https://forge.puppetlabs.com/treydock/)
### disable 
```
sysowner::patch::method:            'disable'
```
#### cron *defaults*
```
sysowner::patch::method:            'cron'
sysowner::patch::cron_reboot:       false, 
sysowner::patch::cron_minute:       '45'
sysowner::patch::cron_hour:         '3'
sysowner::patch::cron_monthday:     '15'
sysowner::patch::cron_month:        '*'
sysowner::patch::cron_weekday:      '1'
sysowner::patch::cron_script_src:   'puppet:///modules/sysowner/sysowner_patch_install.sh'
sysowner::patch::cron_script_dst:   '/usr/local/bin/sysowner_patch_install.sh'
```
#### yum_cron *defaults*
```
sysowner::patch::method:                    'yum_cron'
sysowner::patch::yum_cron_apply_updates:    false
sysowner::patch::yum_cron_download_updates: true
sysowner::patch::yum_cron_days_of_week:     '12345'
sysowner::patch::yum_cron_update_cmd:       'minimal-security'
```
##### sysowner::patch_update_cmd (only valid on EL7)
  - [treydock/yum_cron::update_cmd](https://forge.puppetlabs.com/treydock/yum_cron#update_cmd)
  - sysowner defaults to minimal-security
```
> default                            = yum upgrade
> security                           = yum --security upgrade
> security-severity:Critical         = yum --sec-severity=Critical upgrade
> minimal                            = yum --bugfix upgrade-minimal
> *minimal-security*                   = yum --security upgrade-minimal
> minimal-security-severity:Critical =  --sec-severity=Critical upgrade-minimal
```
## Facts Created
### System Info
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
```
patch_method => disable
```
### patch_method: cron
```
patch_method => cron
patch_cron => 45 3 15 * 1
patch_script => /usr/local/bin/sysowner_patch_install.sh
```
### patch_method: yum_cron
```
patch_method => yum_cron
patch_days_of_week => 12345
patch_download_updates => true
patch_update_cmd => minimal-security
```
## Requires

  - [treydock/yum_cron](https://forge.puppetlabs.com/treydock/yum_cron)
  - [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
