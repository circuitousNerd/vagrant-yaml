# vagrant + yaml setup

## Requirements

1. Install [virtualbox](https://www.virtualbox.org/wiki/Downloads)
2. Install [vagrant](https://www.vagrantup.com/downloads.html)
3. Install vagrant-cachier `vagrant plugin install vagrant-cachier`
> This is a nice to have, it helps speed up the provisioning process if you're constantly destroying and recreating VMs

4. Install vagrant-hosts `vagrant plugin install vagrant-hosts`
> This provides a very simple poor man's DNS for your vagrant environment. VERY helpful for puppet.

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

### Sudo

By design and default the vagrant user has sudo access without requiring a password.

## Quick start

1. Pull the Puppet module dependencies
> This will pull all of the Puppet modules required.

`git submodule update --init --recursive`
2. Start the virtual machine
> This will create the virtual machine and run the initial provisioning including the internal network.

`vagrant up`
3. Re puppet the virtual machine
> We need to re-apply the Puppet after the initial run now that the internal networks are sorted properly.

`vagrant provision --provision-with puppet`
4. Implement SSH workaround for Windows
> Unfortunately vagrant ssh doesn't work on Windows. There is a simple workaround.

`vagrant ssh-config > config`

> Now we can SSH into a virtual machine using:

`ssh -F config <virtual machine name>`

## Supported providers

Currently only supports virtualbox because I am lazy. With a little effort all other supported providers will work.
