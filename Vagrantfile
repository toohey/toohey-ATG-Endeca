# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

ATG_PRIVATE_IP = "192.168.56.5"
ATG_HOSTNAME = "atgbox"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |atg_config|

  # found ready big hdd server box. can use if desktop not needed
  # however, it has old virtulabox addition
  # vagrant box add --name centos65_50G https://googledrive.com/host/0B4tZlTbOXHYWVGpHRWZuTThGVUE/centos65_virtualbox_50G.box

  # for this release 
  # using readymade desktop box "boxcutter/centos65-desktop"
  atg_config.vm.box = "boxcutter/centos65-desktop"
  
  # change memory size
  atg_config.vm.provider "virtualbox" do |v|
    # GUI needed to support ATG tools like ACC locally
    v.gui = true
    v.customize ["modifyvm", :id, "--ioapic", "on"  ]
    v.customize ["modifyvm", :id, "--cpus"  , "4"   ]
    v.customize ["modifyvm", :id, "--memory", 8192 ]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  # vbguest plugin to stop update
  # set auto_update to false, if you do NOT want to check the correct 
  # additions version when booting this machine
  atg_config.vbguest.auto_update = false
  # do NOT download the iso file from a webserver
  atg_config.vbguest.no_remote = true
  
  atg_config.ssh.forward_agent = true
  atg_config.vm.network "private_network", ip: ATG_PRIVATE_IP
  atg_config.vm.hostname = ATG_HOSTNAME
  
  if defined?(VagrantPlugins::HostsUpdater)
    # Pass the found host names to the hostsupdater plugin so it can perform magic.
    atg_config.hostsupdater.aliases = [ATG_HOSTNAME + ".dev"]
    atg_config.hostsupdater.remove_on_suspend = true
  end


  # install software
  atg_config.vm.provision "shell", path: "scripts/provision_jdk.sh"
  
  # provisioning script to setup mysql
  atg_config.vm.provision "shell", path: "scripts/provision_mysql.sh"
  
  # provisioning script to setup endeca
  # some things needs to be run as root
  atg_config.vm.provision "shell", path: "scripts/provision_endeca.sh"
  # but Oracle Universal Installer *will not* install if the user *is* root
  atg_config.vm.provision "shell", path: "scripts/provision_nonroot_endeca.sh", privileged: false
  
  # provisioning script to setup jboss
  atg_config.vm.provision "shell", path: "scripts/provision_jboss.sh", privileged: false

  # provisioning script to install atg and CRS
  atg_config.vm.provision "shell", path: "scripts/provision_atg.sh", privileged: false

  # during development comment setting up atg and test endeca - post installation
  # vagrant halt
  # take snapshot here - manually
  # vagrant up
  # run tests for endeca crs
  # setup CRS EAC app also
  # vagrant halt
  # revert to snapshot taken earlier

  # setup CRS with prod, CA - internal preview
  atg_config.vm.provision "shell", path: "scripts/atg/setup-ps-am.sh", privileged: false
  
  # setup CRS simple config - tested for 11.1 - working
  # atg_config.vm.provision "shell", path: "scripts/atg/setup-crs-simple-nonswitch.sh", privileged: false
  
  # setup full CRS with preview staging and switching
  # atg_config.vm.provision "shell", path: "scripts/atg/setup-crs-pre-stg-switch.sh", privileged: false
  
end
