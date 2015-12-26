# Class: sysowner #

 Manage system owners and support information with facts on system

# Parameters: #

## System parameters:
- system_owners: array of system owner names (should be valid accounts on system)
- system_groups: array of system groups (group on server not required)
- system_note: short description of server usage

## Support parameters:
- support_team: name of OS/Hardware team supporting the system
- support_contact: email contact of support team
- support_level: level of support for system defaults(no-page, work-day, backup-only, 24x7)

## Module behavior parameters:
- fact_template: ERB template to use for writing facts
- fact_file: file location of custom facts
- python_install: true or false: install python and PyYAML
- python_pkg: name of python (rpm/yum) package for install
- python_yaml_pky: name of python module (rpm/yum) package for install

# Actions: #

# Requires: see Modulefile #

# Sample Usage: #
