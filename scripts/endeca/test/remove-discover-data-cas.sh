#after install run from inside VM - vagrant ssh

#testing discover data cas script - remove app
# remove Discover CAS
cd /usr/local/endeca/Apps/Discover/control
DATA_RS_NAME=Discover-data
DIMVALS_RS_NAME=Discover-dimvals
LAST_MILE_CRAWL_NAME=Discover-last-mile-crawl
DVAL_ID_MGR_NAME=Discover-dimension-value-id-manager
CAS_ROOT=/usr/local/endeca/CAS/11.1.0
CAS_HOST=localhost
CAS_PORT=8500
WORKING_DIR=.
sh ${WORKING_DIR}/../config/script/set_environment.sh

${CAS_ROOT}/bin/cas-cmd.sh deleteCrawl -h ${CAS_HOST} -p ${CAS_PORT} -id ${LAST_MILE_CRAWL_NAME}
${CAS_ROOT}/bin/component-manager-cmd.sh delete-component -h ${CAS_HOST} -p ${CAS_PORT} -n ${DATA_RS_NAME}
${CAS_ROOT}/bin/component-manager-cmd.sh delete-component -h ${CAS_HOST} -p ${CAS_PORT} -n ${DIMVALS_RS_NAME}
${CAS_ROOT}/bin/cas-cmd.sh deleteDimensionValueIdManager -h ${CAS_HOST} -p ${CAS_PORT} -m ${DVAL_ID_MGR_NAME}
"${WORKING_DIR}/runcommand.sh" --remove-app

cd /usr/local/endeca/Apps
rm -r Discover
