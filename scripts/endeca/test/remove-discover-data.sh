#after install run from inside VM - vagrant ssh

#testing discover data script - remove app
# remove Discover
cd /usr/local/endeca/Apps/Discover/control
WORKING_DIR=.
sh ${WORKING_DIR}/../config/script/set_environment.sh

"${WORKING_DIR}/runcommand.sh" --remove-app

cd /usr/local/endeca/Apps
rm -r Discover
