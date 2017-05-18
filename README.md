# Class: sysowner

Create facts to be used for system management like owner of systems services and method of patching. Assigning a role allows configuration to be grouped. 

  - system_owners: Contact id for users who are responsible for the services provided by the system. 
  - system_class: Classification of systems by primary usage or application
  - system_role: Used to define configuration for a collection of systems
  - system_group: group or team responsible for the delivered services.
  - system_note: Short description of usage of server. 
  - system_auth: Identify the method of Authentication for the system.  
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
    - myadmin2
sysowner::system_group: "hwadmins"
sysowner::system_note: 'MySQL Database Server'

classes:
    - dba:users
    - dba:mydb
```
## Parameters: 

### Basic system info
  - system_owners: free form array of "system owners", could be emails, local account, names
  - system_class: free form string. ex: general | apache | mysql | oracle | etl | epic
    * use in hiera. ex: "class/%{::system_class}" => class/web.yaml
  - system_role: free form string. ex: general | oracle-hr | mysql-dna | oracle | etl | epic-backup
    * use in hiera. ex: "roles/%{::system_role}" => roles/web.yaml
  - system_group: free form string for team or group. ex: finance | dbas | webx
  - system_auth: free form string to set fact based on authentication method
  - system_note: free form string to describe the server
  
```
sysowner::system_owners: 
  - Henry Winkler
sysowner::system_group: 'hwadmins'
sysowner::system_class: 'common'
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
## Facts Created
### System Info
```
system_class => common
system_role => general
system_group => 'hwadmins' 
system_note => General Purpose Server
system_owners => ["Henry Winkler"]
system_owners_0 = "Hentry Winkler"
support_contact => root@localhost
support_level => no-page
support_team => unix team
```
## Requires

  - [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
