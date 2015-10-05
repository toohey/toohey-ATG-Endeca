echo "installing Endeca"
#these cannot be run as root, else they fail

#MDEX
/vagrant/software/OCmdex6.5.1-Linux64_829811.sh --silent --target /usr/local
source /usr/local/endeca/MDEX/6.5.1/mdex_setup_sh.ini

#Platform Services
/vagrant/software/OCplatformservices11.1.0-Linux64.bin --silent --target /usr/local < /vagrant/scripts/endeca/endeca_platformservices_silent.txt
source /usr/local/endeca/PlatformServices/workspace/setup/installer_sh.ini

#Tools and Frameworks
export ENDECA_TOOLS_ROOT=/usr/local/endeca/ToolsAndFrameworks/11.1.0
export ENDECA_TOOLS_CONF=/usr/local/endeca/ToolsAndFrameworks/11.1.0/server/workspace
/vagrant/software/cd/Disk1/install/silent_install.sh /vagrant/scripts/endeca/endeca_taf_silent_response.rsp ToolsAndFrameworks /usr/local/endeca/ToolsAndFrameworks admin
#universal installer cannot run as root, but following must run as root
sudo /home/vagrant/oraInventory/orainstRoot.sh

#CAS
/vagrant/software/OCcas11.1.0-Linux64.sh --silent --target /usr/local <  /vagrant/scripts/endeca/endeca_cas_silent.txt



echo "setting up endeca services"

sudo cp /vagrant/scripts/endeca/init-scripts/endecaplatform /etc/init.d/endecaplatform
sudo chmod 750 /etc/init.d/endecaplatform
sudo chkconfig --add endecaplatform

sudo cp /vagrant/scripts/endeca/init-scripts/endecaworkbench /etc/init.d/endecaworkbench
sudo chmod 750 /etc/init.d/endecaworkbench
sudo chkconfig --add endecaworkbench

sudo cp /vagrant/scripts/endeca/init-scripts/endecacas /etc/init.d/endecacas
sudo chmod 750 /etc/init.d/endecacas
sudo chkconfig --add endecacas

#copy endeca setup script
mkdir -p /home/vagrant/scripts
cp /vagrant/scripts/endeca/start_endeca_services.sh /home/vagrant/scripts
cp /vagrant/scripts/endeca/stop_endeca_services.sh /home/vagrant/scripts
chmod +x scripts/start_endeca_services.sh
chmod +x scripts/stop_endeca_services.sh

echo "endeca service setup complete"

#Start Endeca Services

# stop first in case something got started as part of installation
# /home/vagrant/scripts/stop_endeca_services.sh
/home/vagrant/scripts/start_endeca_services.sh

echo "done installing endeca and starting services"