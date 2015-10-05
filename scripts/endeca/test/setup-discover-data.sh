#after install run from inside VM - vagrant ssh

#testing discover data script
# setup Discover
cd /usr/local/endeca/Apps
/usr/local/endeca/ToolsAndFrameworks/11.1.0/deployment_template/bin/deploy.sh --install-config /vagrant/scripts/endeca/test/test-dicover-data.xml --no-prompt
cd /usr/local/endeca/Apps/Discover/control
./initialize_services.sh
./load_baseline_test_data.sh
./baseline_update.sh
./promote_content.sh
echo "login to workbench using admin/admin at http://atgbox.dev:8006/ using Google Chrome browser"
echo "check out http://atgbox.dev:8006/discover"
echo "check out http://atgbox.dev:8006/discover-authoring"
echo "ref app http://atgbox.dev:8006/endeca_jspref"
echo "no case crawl at http://atgbox.dev:8006/ifcr/admin/casconsole.html (takes time)"
