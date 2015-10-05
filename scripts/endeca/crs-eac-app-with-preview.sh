#after install run from inside VM - vagrant ssh

# cd /usr/local/endeca/Apps/CRS/control/
# ./runcommand.sh --remove-app
# cd
# rm -r /usr/local/endeca/Apps/CRS
# mkdir -p /home/vagrant/temp/deploy/
# cp -r /home/vagrant/ATG/ATG11.1/CommerceReferenceStore/Store/Storefront/deploy/* /home/vagrant/temp/deploy/

# setup CRS CAS
cd /usr/local/endeca/Apps
/usr/local/endeca/ToolsAndFrameworks/11.1.0/deployment_template/bin/deploy.sh --install-config /vagrant/scripts/endeca/crs-eac-app-with-preview.xml --no-prompt
cd /usr/local/endeca/Apps/CRS/control
./initialize_services.sh
 # --force
echo "**Endeca CRS app in still not up!"
echo "do full deployment from bcc to production"
echo "then trigger endeca baseline update from atg dyn/admin"
echo "then run ./promote_content in endeca app"
echo "login to workbench using admin/admin at http://atgbox.dev:8006/ using Google Chrome browser"
echo "ref app http://atgbox.dev:8006/endeca_jspref"
echo "cas crawl at http://atgbox.dev:8006/ifcr/admin/casconsole.html (takes time)"
echo "********************************"
# rm -rf /home/vagrant/temp