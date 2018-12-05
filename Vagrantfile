# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

machines = YAML.load_file(File.join(File.dirname(__FILE__), 'machines.yaml'))

Vagrant.configure(2) do |config|

  machines.each do |machines|

    config.vm.define machines["name"] do |machine|
      machine.vm.box = machines["box"]
      machine.vm.hostname = machines["name"]
      machine.vm.synced_folder './', '/vagrant' 
      
      if Vagrant.has_plugin?("vagrant-cachier")
        config.cache.scope = :box
      end
      
      # If extra NICs are defined, create them
      if machines["nic"]
        nic = machines["nic"]
        nic.each do |nic|
          machine.vm.network nic["type"], ip: nic["ip"]
        end
      end

      # If forwarded ports are defined, forward them
      if machines["port"]
        port = machines["port"]
        port.each do |port|
          machine.vm.network "forwarded_port", guest: port["guest"], host: port["host"]
        end
      end
      machine.vm.provider "libvirt" do |vb|
        vb.memory = machines["ram"]
        vb.cpus = machines['cpu']
      end
    end
    config.vm.provision "hosts", :sync_hosts => true
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo yum install -y https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
    sudo yum -y install puppet
    sudo systemctl restart network
  SHELL

  config.vm.provision "puppet" do |puppet|
    puppet.environment_path = 'environments'
    puppet.environment = 'development'
    puppet.manifests_path = "environments/development/manifests"
    puppet.manifest_file = "default.pp"
    puppet.module_path = "environments/development/modules"
    puppet.hiera_config_path = "hiera.yaml"
    puppet.working_directory = "/tmp/vagrant-puppet"
  end
end
