#!/usr/bin/env bash
# sudo apt-get update
# sudo apt-get install -y nodejs
# sudo apt-get install -y npm


cd ~/data_infrastructure/orestar_scrape

sudo npm install

cd orestar_scrape_committees

sudo npm install


cd ..
cd filed_date_and_tran_date
sudo npm install


cd ..
cd scrape_by_filed_date_and_id
sudo npm install