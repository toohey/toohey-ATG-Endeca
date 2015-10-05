# install the mysql driver as jboss module
mkdir -p /home/vagrant/jboss/modules/com/mysql/main
cp /vagrant/software/mysql-connector-java-5.1.36-bin.jar /home/vagrant/jboss/modules/com/mysql/main
cp /vagrant/scripts/jboss/module.xml /home/vagrant/jboss/modules/com/mysql/main


# commerce platform
echo "installing ATG Platform 11.1 ..."
/vagrant/software/OCPlatform11.1.bin -i silent -f /vagrant/scripts/atg/OCPlatform11.1.properties
echo "ATG Platform 11.1 installation complete"

# CRS
echo "installing ATG CRS 11.1 ..."
/vagrant/software/OCReferenceStore11.1.bin -i silent
echo "ATG CRS 11.1 installation complete"
