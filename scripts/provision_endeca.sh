echo "Endeca setup"
#these need to run as root, else they fail

# directories
mkdir -p /usr/local/endeca/Apps
chmod -R 755 /usr/local/endeca
chown -R vagrant:vagrant /usr/local/endeca

# set environment variables
echo "source /usr/local/endeca/MDEX/6.5.1/mdex_setup_sh.ini" >> /home/vagrant/.bash_profile \
 && echo "source /usr/local/endeca/PlatformServices/workspace/setup/installer_sh.ini" >> /home/vagrant/.bash_profile \
 && echo "export ENDECA_TOOLS_ROOT=/usr/local/endeca/ToolsAndFrameworks/11.1.0" >> /home/vagrant/.bash_profile \
 && echo "export ENDECA_TOOLS_CONF=/usr/local/endeca/ToolsAndFrameworks/11.1.0/server/workspace" >> /home/vagrant/.bash_profile

echo "done endeca setup"
