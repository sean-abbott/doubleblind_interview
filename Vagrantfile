# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
require 'yaml'

settings = YAML.load_file 'local_config.yml'

Vagrant.configure(2) do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  config.ssh.forward_agent = true
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "desktop" do |desktop|
    desktop.vm.box = "bento/ubuntu-16.04"
    desktop.vm.hostname = "desktop.interview.vm"
    desktop.vm.box_check_update = true
    desktop.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioning/desktop.yml"
      ansible.extra_vars = "local_ansible_vars.yml"
      ansible.groups = {
        "dev" => ["desktop"]
      }
      #ansible.verbose = 'vvvv'
    end
    desktop.vm.network "forwarded_port", guest: 5901, host: 5901
    desktop.vm.network "forwarded_port", guest: 3389, host: 3389
    desktop.vm.network "forwarded_port", guest: 7667, host: 7667

    desktop.vm.provider "virtualbox" do |vb, override|
      vb.name = "desktop"
      vb.gui = true
      override.vm.network "private_network", ip: "192.168.0.3"
    end
  end
  
  config.vm.define "control" do |control|
    control.vm.box = "bento/ubuntu-16.04"
    control.vm.hostname = "control.interview.vm"
    control.vm.box_check_update = true
    control.vm.network "forwarded_port", guest: 5601, host: 5601
    control.vm.network "forwarded_port", guest: 9200, host: 9200
    control.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioning/control.yml"
      ansible.groups = {
        "dev" => ["control"]
      }
    end

    control.vm.provider "virtualbox" do |vb, override|
      vb.name = "control"
      override.vm.network "private_network", ip: "192.168.0.9"
      vb.memory = 2048
      vb.cpus = 2
      vb.linked_clone = true
      vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
    end
  end

  config.vm.define "db" do |db|
    db.vm.box = "bento/ubuntu-16.04"
    db.vm.hostname = "db.interview.vm"
    db.vm.box_check_update = true
    db.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioning/db.yml"
      ansible.groups = {
        "dev" => ["db"]
      }
    end

    db.vm.provider "virtualbox" do |vb, override|
      override.vm.network "private_network", ip: "192.168.0.10"
      vb.memory = 2048
      vb.cpus = 2
      vb.linked_clone = true
      vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
    end
  end

  config.vm.define "app" do |app|
    app.vm.box = "bento/ubuntu-16.04"
    app.vm.hostname = "app.interview.vm"
    app.vm.box_check_update = true
    app.hostmanager.aliases = %w(dev.interview.vm)
    app.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioning/app.yml"
      ansible.groups = {
        "dev" => ["app"],
      }
      ansible.host_key_checking = false
#      ansible.verbose = 'vvvv'
    end

    app.vm.provider "virtualbox" do |vb, override|
      override.vm.network "private_network", ip: "192.168.0.20"
      vb.memory = 1024
      vb.cpus = 1
      vb.linked_clone = true
      vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
    end
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioning/dev.yml"
    ansible.groups = {
      "desktops" => ["desktop"],
      "servers" => ["app", "db", "control"],
      "dev:children" => ["servers", "desktops"]
    }
  end
end
