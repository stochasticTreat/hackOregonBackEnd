#!/usr/bin/env bash
echo "This script should be run by entering the command: "
echo "buildOutFromGitRepo.sh"
echo "from the backend git repo's directory."
echo "If the hack oregon back end is in a Vagrant machine, the git directory will be:"
echo " /vagrant "

if [ -e ~/data_infrastructure ]
then
	echo "data_infrastructure folder already exists"
else
	echo "creating data_infrastructure folder"
	sudo mkdir ~/data_infrastructure
fi

echo "current working directory inside buildOutFromGitRepo:"
pwd

sudo chmod 777 addDirectionCodes.sh
sudo chmod 777 buildEndpointTables.sh
sudo chmod 777 buildOutDBFromRawTables.sh
sudo chmod 777 buildScraper.sh
sudo chmod 777 dataWorkUp.sh
sudo chmod 777 workingTableCreation.sh
sudo chmod 777 makeWorkingCandidateFilings.R
sudo chmod 777 endpoints/makeGrassState.R
sudo chmod 777 postSchemaInstallationEndpoints.sh

#core raw database files
sudo cp -v ./trimTransactionsTable.sql ~/data_infrastructure/trimTransactionsTable.sql
sudo cp -v ./install.sql ~/data_infrastructure/install.sql

#control script
sudo cp -v ./buildOutDBFromRawTables.sh ~/data_infrastructure/buildOutDBFromRawTables.sh
sudo cp -v ./.Rprofile ~/.Rprofile

#scraper infrastructure
sudo cp -avr ./endpoints ~/data_infrastructure/endpoints 
sudo cp -avr ./orestar_scrape ~/data_infrastructure/orestar_scrape
sudo chmod 777 orestar_scrape/bulkAddTransactions.R

#working tables
sudo cp -v ./addDirectionCodes.sh ~/data_infrastructure/addDirectionCodes.sh
sudo cp -v ./moneyDirectionCodes.txt ~/data_infrastructure/moneyDirectionCodes.txt 
sudo cp -v ./workingTableCreation.sh ~/data_infrastructure/workingTableCreation.sh
sudo cp -v ./workingTransactionsTableCreation.sql ~/data_infrastructure/workingTransactionsTableCreation.sql
sudo cp -v ./makeWorkingCandidateFilings.R ~/data_infrastructure/makeWorkingCandidateFilings.R
sudo cp -v ./buildEndpointTables.sh ~/data_infrastructure/buildEndpointTables.sh
#endpoints
sudo cp -v ./postSchemaInstallationEndpoints.sh ~/data_infrastructure/postSchemaInstallationEndpoints.sh

