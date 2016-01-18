#!/bin/env python

import yaml

with open('/etc/system_owners_facts.yaml', 'r') as f:
    doc = yaml.load(f)

