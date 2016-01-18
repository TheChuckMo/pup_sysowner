# Class: sysowner

 Manage system owners and groups, system role, and patch updating. 

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
### Optional client facts
 Allows a configuration for a "client" to be defined and applied to systems across roles.  My primary use case is database clients.
  - sysowner::clients:oracle: true              # should the components required for this client be installed
    
  Use in hiera:  
  - "clients/oracle_%{::clients_oracle}"
  - yaml file: {datadir]/clients/oracle_true.yaml
  
```
sysowner::clients:oracle: false
```
### Patch methods - disable | cron | yum_cron
  Control the method of patching. 
  - disable: Will remove script or yum_cron configuration 
  - cron: Push out a custom script (you write) and create a cron entry to run script. 
  - yum_cron: Use the yum_cron tool to schedule patching and set installed patch level.
    *uses Puppet module: [treydock/yum_cron::update_cmd](https://forge.puppetlabs.com/treydock/)
### disable 
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
### Clients 
```
clients_{client_key} => {client_value}
clients_oracle => false
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
