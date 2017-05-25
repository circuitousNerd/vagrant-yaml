# vagrant + yaml setup

## Quick start

1. Edit the machines.yaml file
  1. Add a name
  2. Specify a box
  3. Specify amount of RAM
  4. Specify number of vCPUs
  5. ```vagrant up```
eg.
```
---
- name: "default"
  box: "centos/7"
  nic:
  #  - {type: "", ip: ""}
  port:
  #  - {guest: "80", host: "8080"}
  #  - {guest: "443", host: "4443"}
  ram: 1024
  cpu: 1
```
## Customising NICs

1. Specify a type eg. Private Network, Public Network
  1. Specify IP.
eg.
```
---
- name: ""
  box: "centos/7"
  nic:
    - {type: "Private Network", ip: "192.168.1.10"}
  port:
  #  - {guest: "80", host: "8080"}
  #  - {guest: "443", host: "4443"}
  ram:  
  cpu:
```

## Port Forwarding

1. Provide a hash of the guest port and the host port.

eg.
```
---
- name: ""
  box: "centos/7"
  nic:
  #  - {type: "", ip: ""}
  port:
    - {guest: "80", host: "8080"}
    - {guest: "443", host: "4443"}
  ram:  
  cpu:
```


## Supported providers

Currently onl supports virtualbox because I am lazy. With a little effort all other supported providers will work.
