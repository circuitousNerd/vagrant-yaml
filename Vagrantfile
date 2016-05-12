# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

machines = YAML.load_file(File.join(File.dirname(__FILE__), 'machines.yaml'))

Vagrant.configure(2) do |config|
   
  machines.each do |machines|
    config.vm.define machines["name"] do |machine|
      machine.vm.box = machines["box"]
      machine.vm.hostname = machines["name"]
      machine.vm.synced_folder './', '/vagrant', type: 'rsync' 
      
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
      machine.vm.provider "libvirt" do |lib|
        lib.memory = machines["ram"]
        lib.cpus = machines["cpu"]
        lib.nested = machines["nested"]
      end
    end
    config.vm.provision "hosts", :sync_hosts => true
  end

  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
end
