
# copy mysql driver into atg installation
mkdir ~/ATG/ATG11.1/mysql
cp /vagrant/software/mysql-connector-java-5.1.36-bin.jar ~/ATG/ATG11.1/mysql/

# convenience for most object updates:
# install jcliff for simpler update using jboss-cli
sudo rpm -ivh /vagrant/software/jcliff-2.10.7-1.noarch.rpm

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
# crs_simple_nonswitch - 2 db, 2 instances
# connection pools: crs_coreDS, crs_verDS
# crs_ps:8180 connect to crs_coreDS
# crs_am:8280 connect to crs_coreDS, crs_verDS 
# use existing jboss instances and configue
# appropriate in ATG

# create db in mysql as CIM cant create it
mysql -u root -proot -e 'create database crs_core'
mysql -u root -proot -e 'create database crs_ver'

# copy jboss server setup (or manually do it as per install ):
cp /vagrant/crs_artifacts/crs_simple_nonswitch/run_*.sh ~/jboss/bin/
chmod +x ~/jboss/bin/run_*.sh
cp /vagrant/crs_artifacts/crs_simple_nonswitch/*.xml ~/jboss/standalone/configuration/
cp /vagrant/crs_artifacts/crs_simple_nonswitch/tail*.sh ~/
chmod +x ~/tail*.sh

/home/vagrant/ATG/ATG11.1/home/bin/cim.sh -batch /vagrant/crs_artifacts/crs_simple_nonswitch/batch.cim

# exit cim
# endeca EAC app CRS needs to be deployed outside CIM - automate it!
# this is crs dev non switching:
/vagrant/scripts/endeca/crs-eac-app-setup.sh

# atg CIM deployment updates deployment scanner for jboss instance
# hence copy correct files after that
cp /vagrant/crs_artifacts/crs_simple_nonswitch/run_*.sh ~/jboss/bin/
chmod +x ~/jboss/bin/run_*.sh
cp /vagrant/crs_artifacts/crs_simple_nonswitch/*.xml ~/jboss/standalone/configuration/

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
bin/run_crs_ps.sh > /dev/null 2>&1 &
bin/run_crs_am.sh > /dev/null 2>&1 &

# full deployment
echo "wait for servers to start"
echo "goto BCC and do full deployment"
echo "*****************************************************"
echo "use Google Chrome to login as admin/Password1 on http://atgbox.dev:8280/atg/bcc"
echo "CA console > configuration > import from xml"
echo "click choose file"
echo "file /crs_artifacts/crs_simple_nonswitch/deploymentTopology.xml"
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
	echo "run /usr/local/endeca/Apps/CRS/control/promote_content.sh"
fi

