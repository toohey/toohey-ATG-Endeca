# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

ATG_PRIVATE_IP = "192.168.60.5"
ATG_HOSTNAME = "atgbox"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |atg_config|

  atg_config.vm.box = "toohey-centos65"
  
  # change memory size
  atg_config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--ioapic", "on"  ]
    v.customize ["modifyvm", :id, "--cpus"  , "4"   ]
    v.customize ["modifyvm", :id, "--memory", 10240]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
  
  
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
  
  # reduce size of temp virtual machine
  atg_config.vm.provision "shell", path: "scripts/provision_cleanup.sh", privileged: true
  

end
