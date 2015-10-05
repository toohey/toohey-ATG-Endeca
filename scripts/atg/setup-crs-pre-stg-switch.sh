# bug fix for linux
# -bash: fork: retry: Resource temporarily unavailable
# -bash: fork: Resource temporarily unavailable
# https://access.redhat.com/solutions/543503
# cat /etc/security/limits.d/90-nproc.conf
# Lets do this only if we hit limit again
# sudo cp /vagrant/bugfix/90-nproc.conf /etc/security/limits.d/90-nproc.conf
# sudo chown root:root /etc/security/limits.d/90-nproc.conf
# echo "nproc fix applied ... maybe that was causing endeca related failure"

# copy mysql driver into atg installation
mkdir ~/ATG/ATG11.1/mysql
cp /vagrant/software/mysql-connector-java-5.1.36-bin.jar ~/ATG/ATG11.1/mysql/

# convenience for most object updates:
# install jcliff for simpler update using jboss-cli
# sudo rpm -i /vagrant/software/jcliff-2.10.7-1.noarch.rpm

# need to setup jboss server
# add mysql driver to jboss as module - only once
mkdir -p /home/vagrant/jboss/modules/com/mysql/main
cp /vagrant/software/mysql-connector-java-5.1.36-bin.jar /home/vagrant/jboss/modules/com/mysql/main
cp /vagrant/scripts/jboss/module.xml /home/vagrant/jboss/modules/com/mysql/main

# create jboss server instances and use it from CIM
# DON't create jboss instances using CIM
# also dont do post deploy tasks to jboss installation
# this is currently done manually
# may automate it in future - for now manual
# crs_pre_stg_switch - 5 db, 3 instances
# connection pools: crs_coreDS, crs_verDS
# crs_ps:8180 connect to crs_coreDS, crs_cataDS, crs_catbDS
# crs_stg:8080 connect to crs_stgDS
# crs_am:8280 connect to crs_coreDS, crs_cataDS, crs_catbDS, crs_stgDS, crs_verDS
# use existing jboss instances and configue
# appropriate in ATG

# create db in mysql as CIM cant create it
mysql -u root -proot -e 'create database crs_core'
mysql -u root -proot -e 'create database crs_cata'
mysql -u root -proot -e 'create database crs_catb'
mysql -u root -proot -e 'create database crs_stg'
mysql -u root -proot -e 'create database crs_ver'

# copy jboss server setup (or manually do it as per install ):
cp /vagrant/crs_artifacts/crs_pre_stg_switch/run_*.sh ~/jboss/bin/
chmod +x ~/jboss/bin/run_*.sh
cp /vagrant/crs_artifacts/crs_pre_stg_switch/crs*.xml ~/jboss/standalone/configuration/
cp /vagrant/crs_artifacts/crs_pre_stg_switch/tail*.sh ~/
chmod +x ~/tail*.sh

/home/vagrant/ATG/ATG11.1/home/bin/cim.sh -batch /vagrant/crs_artifacts/crs_pre_stg_switch/batch.cim

# uses:
# /home/vagrant/ATG/ATG11.1/home/security/crs_pre_stg_switch
# /usr/local/endeca/Apps/CRS/data/workbench/application_export_archive/CRS


# exit cim
# endeca EAC app CRS needs to be deployed outside CIM
/vagrant/scripts/endeca/crs-eac-app-with-preview.sh

# # endeca workbench password was not admin. so maybe sling was corrupt
# # https://community.oracle.com/message/12895542
# # Stop the Endeca TAF service
# ~/scripts/stop_endeca_services.sh
# # remove the C:\Endeca\ToolsAndFrameworks_1\11.1.0\server\workspace\state\sling folder
# rm -r /usr/local/endeca/ToolsAndFrameworks/11.1.0/server/workspace/state/sling
# # start the Endeca TAS service
# ~/scripts/start_endeca_services.sh
# # update credential - interactive
# cd /usr/local/endeca/ToolsAndFrameworks/11.1.0/credential_store/bin
# ./manage_credentials.sh delete --user admin --key ifcr
# echo "enter admin as password (twice) ... not automated yet"
#
# # ./manage_credentials.sh add --user admin --key ifcr



# atg CIM deployment updates deployment scanner for jboss instance
# hence copy correct files after that
cp /vagrant/crs_artifacts/crs_pre_stg_switch/crs*.xml ~/jboss/standalone/configuration/

# fix other configuration problems
# in /home/vagrant/ATG/ATG11.1/home/servers/crs_ps/localconfig/atg/endeca/ApplicationConfiguration.properties add
# keyToApplicationName=default=CRS
# 
echo "keyToApplicationName=default=CRS" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_ps/localconfig/atg/endeca/ApplicationConfiguration.properties
# create in ca instance /atg/search/SynchronizationInvoker.properties with
# host=locahost
# port=8860
mkdir -p /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/search/
echo "host=localhost" > /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/search/SynchronizationInvoker.properties \
	&& echo "port=8861" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/search/SynchronizationInvoker.properties

# create in ca instance /atg/deployment/DeploymentManager.properties
# maxThreads=1
# useDistributedDeployment=false
mkdir -p /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/deployment/
echo "maxThreads=1" > /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/deployment/DeploymentManager.properties \
	&& echo "useDistributedDeployment=false" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/deployment/DeploymentManager.properties

# in ca and prod instance, disable rest security - used in user segment sharing
# /atg/rest/security/RequestCredentialAccessController.enable=false
# maybe only needed in ca server since that is segment server - later
mkdir -p /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/rest/security/
echo "enabled=false" > /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/rest/security/RequestCredentialAccessController.properties
mkdir -p /home/vagrant/ATG/ATG11.1/home/servers/crs_ps/localconfig/atg/rest/security/
echo "enabled=false" > /home/vagrant/ATG/ATG11.1/home/servers/crs_ps/localconfig/atg/rest/security/RequestCredentialAccessController.properties

# for supporting incremental change in pub server config:
# /atg/commerce/search/ProductCatalogOutputConfig
# /atg/commerce/search/StoreLocationOutputConfig
# /atg/commerce/endeca/index/CategoryToDimensionOutputConfig
# /atg/content/search/ArticleOutputConfig
# /atg/content/search/MediaContentOutputConfig
# ensure targetName=Production is not commented
echo "targetName=Production" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/commerce/search/ProductCatalogOutputConfig.properties
echo "targetName=Production" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/commerce/search/StoreLocationOutputConfig.properties
echo "targetName=Production" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/commerce/endeca/index/CategoryToDimensionOutputConfig.properties
echo "targetName=Production" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/content/search/ArticleOutputConfig.properties
echo "targetName=Production" >> /home/vagrant/ATG/ATG11.1/home/servers/crs_am/localconfig/atg/content/search/MediaContentOutputConfig.properties


#run jboss server (standalone) - separate window for convenience
cd /home/vagrant/jboss
bin/run_crs_ps.sh > /dev/null &
bin/run_crs_stg.sh > /dev/null &
bin/run_crs_am.sh > /dev/null  &


# full deployment
echo "wait for servers to start"
echo "goto BCC and do full deployment"
echo "*****************************************************"
echo "use Google Chrome to login as admin/Password1 on http://atgbox.dev:8280/atg/bcc"
echo "CA console > configuration > import from xml"
echo "click choose file"
echo "file /crs_artifacts/crs_pre_stg_switch/deploymentTopology.xml"
echo "click ok .. then cancel (atg bug shows dialog box again)"
echo "click configuration on left again"
echo "make changes live"
echo "do full deployment"
echo "click make changes live ... take a few minutes ... "
echo "./tail-crs_am.sh ... check for ... purging deployemnt data"
echo "./tail-crs_ps.sh ... check for ... BaselineUpdate for application CRS finished with status NotRunning"
echo "*****************************************************"
echo ""
# currently this is not working, so script exits
read -n1 -r -p "Press space to promote content or anything else to exit ..." key

if [ "$key" = ' ' ]; then
    # Space pressed
	# promote_content in endeca
	# 
	/usr/local/endeca/Apps/CRS/control/promote_content.sh
else
    # Anything else pressed, do whatever else.
	# product showing http://atgbox.dev:8180/crs/storeus/browse/productDetailSingleSku.jsp?categoryNavIds=cat10016&navAction=push&categoryNav=true&categoryId=cat10016&productId=xprod2032&navCount=3
	# category not showing
	# workbench not authenticating to get segment means maybe config not picked.
	# just ATG working
	echo "remember to promote content else CRS homepage will not show"
	echo "product page will show"
	echo ""
	echo "*****************************************************"
	echo "*****************************************************"
	echo "*****************************************************"
	echo "*****************************************************"
	echo "*****************************************************"
	echo "*****************************************************"
	echo "run /usr/local/endeca/Apps/CRS/control/promote_content.sh"
	echo "AFTER full deployment ... CRS homepage doesnt show"
	echo "*****************************************************"
	echo "*****************************************************"
	echo "*****************************************************"
	echo "*****************************************************"
fi
	
# create box
# remove temp files
# sudo yum clean all
# sudo rm -rf /tmp/*
# sudo rm -f /var/log/wtmp /var/log/btmp
# sudo dd if=/dev/zero of=/EMPTY bs=1M
# sudo rm -f /EMPTY
# cat /dev/null > ~/.bash_history && history -c && exit
# output to new box
# vagrant package --output toohey-centos65.box
# vagrant box add toohey-centos65 toohey-centos65.box
# vagrant destroy

# tests:
# CRS production homepage showing
# CRS stating homepage showing
# XM segments from BCC showing
# BCC incremental deployment working - try a project
# BCC preview working

# todos:
# more space saving ideas - temp files deletion
# endeca logs - multiple places
# jboss work in progress files
# atg logs
# mysql errors, logs
# atg temp files
# guest additions update... versions in sync with all platforms
# convenience shortcuts / scripts / mappings /etc
# need some way to know jboss server startup is complete
# easy way to start jboss servers



# fixes to be done 
# preview not working
# 20:50:51,265 WARN  [nucleusNamespace.atg.dynamo.service.preview.PreviewURLManager] (http-/0.0.0.0:8280-2) defaultPreviewURL property is not set
# 20:50:51,266 WARN  [nucleusNamespace.atg.dynamo.service.preview.PreviewURLManager] (http-/0.0.0.0:8280-2) defaultNoAssetPreviewURL property is not set
