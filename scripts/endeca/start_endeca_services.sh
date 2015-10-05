# platform
# /usr/local/endeca/PlatformServices/11.1.0/tools/server/bin/startup.sh
# Logs are written to `/usr/local/endeca/PlatformServices/workspace/logs`

# tools
# /usr/local/endeca/ToolsAndFrameworks/11.1.0/server/bin/startup.sh 
# Logs are written to `/usr/local/endeca/ToolsAndFrameworks/11.1.0/server/workspace/logs`

# cas
# /usr/local/endeca/CAS/11.1.0/bin/cas-service.sh &
# Logs are written to `/usr/local/endeca/CAS/workspace/logs`

sudo service endecaplatform start
sudo service endecaworkbench start
sudo service endecacas start
