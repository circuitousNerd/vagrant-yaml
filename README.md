# vagrant + yaml setup

## Finished Product

This config will result in a virtual machine running elasticsearch and kibana with an locally accessible IP of 10.100.0.10.

### Ports
| Service | IP | Port
| ------- | -- | ----
Elasticsearch HTTP | 10.100.0.10 | 9200
Elasticsearch Transport | 10.100.0.10 | 9300
Kibana | 10.100.0.10 | 5601

### Sudo

By design and default the vagrant user has sudo access without requiring a password.

## Quick start

1. Pull the Puppet module dependencies
> This will pull all of the Puppet modules required.

`git submodule update`
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


## Requirements

1. Install [virtualbox](https://www.virtualbox.org/wiki/Downloads)
2. Install [vagrant](https://www.vagrantup.com/downloads.html)
3. Install vagrant-cachier `vagrant plugin install vagrant-cachier`
4. Install vagrant-hosts `vagrant plugin install vagrant-hosts`

## Supported providers

Currently only supports virtualbox because I am lazy. With a little effort all other supported providers will work.
