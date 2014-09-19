#!/bin/bash

if [ -e ./hackoregon.sql.bz2 ]
then
	echo "hackoregon.sql.bz2 found"
else
	echo "hackoregon.sql.bz2 not found, downloading..."
	wget  http://s3-us-west-2.amazonaws.com/mp-orestar-dump/hackoregon.sql.bz2
fi

sudo mkdir ~/data_infrastructure

sudo cp ./hackoregon.sql.bz2 ~/data_infrastructure/hackoregon.sql.bz2

sudo ./buildoutFromGitRepo.sh

cd ~
cwd=$(pwd)
datadir="${cwd}/data_infrastructure"
cd $datadir

echo "install3.sh changed the working directory to:"
pwd

sudo bunzip2 ./hackoregon.sql.bz2
sudo -u postgres psql -c 'CREATE DATABASE hackoregon;'

sudo -u postgres psql hackoregon < ./hackoregon.sql

sudo -u postgres psql hackoregon < ./trimTransactionsTable.sql

sudo -u postgres createlang plpgsql

# sudo -u postgres psql hackoregon < ./campaign_detail.sql #will try building this on the fly... 

sudo -u postgres psql -c "alter user postgres password 'points';"

sudo ./buildOutDBFromRawTables.sh

