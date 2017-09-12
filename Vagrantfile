# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
#

config_file=File.expand_path(File.join(File.dirname(__FILE__), 'vagrant_variables.yml'))
settings=YAML.load_file(config_file)

MEMORY              = settings['vm_memory']
CPUS                = settings['vm_cpus']

CLUSTER             = settings['cluster']
NNODES              = settings['nnodes']

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Disable the new default behavior introduced in Vagrant 1.7, to
  # ensure that all Vagrant machines will use the same SSH key pair.
  # See https://github.com/mitchellh/vagrant/issues/5005
  # And https://github.com/mitchellh/vagrant/issues/5048
  config.ssh.insert_key = false

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  if ARGV[1] == "ssh"
    config.ssh.forward_agent = true
  else
    config.ssh.forward_agent = false
  end

  # setup /etc/hosts for our nodes defined here
  config.hostmanager.enabled = true
  config.hostmanager.manage_guest = true
  # No need for host->guest yet
  config.hostmanager.manage_host = false
  config.hostmanager.include_offline = true

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Virtualbox, assuming on developer machine
  config.vm.provider :virtualbox do |vb,override|
      # Base Centos7 box, no real magic
      override.vm.box = "geerlingguy/centos7"
      override.vbguest.auto_update = false
  end

  config.vm.synced_folder '.', '/vagrant', disabled: true

  # TODO:
  # - add syntax (--syntax-check) step before running
  # - add variable to test idempotence (changed=0, etc)

  # Add nodes
  (0..NNODES - 1).each do |i|
      config.vm.define "#{CLUSTER}#{i}" do |node|
        node.vm.hostname = "#{CLUSTER}#{i}"
        # a private (dev box only) network
        node.vm.network "private_network", type: "dhcp"

        node.vm.provider "virtualbox" do |vb,override|
          vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

          # Customize the amount of memory on the VM:
          vb.memory = "#{MEMORY}"
          vb.cpus = "#{CPUS}"
        end

      # Vagrant's "change host name" capability for RedHat
      # maps hostname to loopback, conflicting with hostmanager.
      # We must repair /etc/hosts
      node.vm.provision "shell",
        inline: "sed -ri 's/127\.0\.0\.1\s.*/127.0.0.1 localhost localhost.localdomain/' /etc/hosts; echo done; exit"


      # run ansible once all nodes are up
      if i == NNODES - 1

        #
        # NOTE: Requires ansible in your environment, see setup_ansible.sh
        #
        node.vm.provision "ansible" do |ansible|
          ansible.playbook      = "test/test.yml"
          ansible.limit         = "all"
        end
      end
    end
  end
end
