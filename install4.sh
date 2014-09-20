#!/bin/bash
#R installation
#using instructions from here: http://cran.r-project.org/bin/linux/ubuntu/README
#cran mirror: http://ftp.osuosl.org/pub/cran/

#add this entry to the /etc/apt/sources.list file: deb http://http://ftp.osuosl.org/pub/cran/bin/linux/ubuntu lucid/

echo "deb http://http://ftp.osuosl.org/pub/cran/bin/linux/ubuntu trusty/" >> ./sources.list.appendme
sudo cat /etc/apt/sources.list ./sources.list.appendme  > ./sources.list.tmp
sudo mv ./sources.list.tmp /etc/apt/sources.list
rm ./sources.list.appendme

sudo apt-get update
sudo apt-get -y install r-base
sudo apt-get -y install r-base-dev

#create a R library for the user:
echo R_LIBS_USER=\"~/lib/R/library\" > ~/.Renviron
mkdir ~/lib/R/library
sudo cp ./Rprofile ~/.Rprofile

#install java so that some r packages will work.
#https://www.digitalocean.com/community/tutorials/how-to-install-java-on-ubuntu-with-apt-get

#installing the needed development kit
#for xls import
sudo apt-get -y install default-jdk

#node scraper installation

sudo apt-get -y install nodejs
sudo apt-get -y install 
sudo apt-get install -y npm

sudo ./buildScraper.sh
# cd orestar_scrape
# sudo npm install 
# cd orestar_scrape_committees
# sudo npm install

sudo ./buildOutDBFromRawTables.sh
