#!/usr/bin/env bash
#scripts to create the working tables and run the data workup

#sudo -u postgres psql hackoregon < ~/gitforks/backend/dataWorkUp.sql

echo "Running buildOutDBFromRawTables.sh"

sudo ~/data_infrastructure/workingTableCreation.sh

sudo ~/data_infrastructure/buildEndpointTables.sh

sudo -u postgres psql hackoregon <  ./install.sql

sudo ~/data_infrastructure/postSchemaInstallationEndpoints.sh




