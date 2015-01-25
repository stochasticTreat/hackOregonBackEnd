#!/usr/bin/Rscript
cat("\nRunning bulkLoadScrapedCommitteeData.R\n",
		"from working directory:\n",
		getwd(),"\n")

setwd("~/data_infrastructure/orestar_scrape/")
source('./runScraper.R')
dbname="hackoregon"
# dbname = "hack_oregon"

bulkLoadScrapedCommitteeData(committeefolder="raw_committee_data", 
														 dbname=dbname, 
														 comTabName="raw_committees_scraped")
cat("\n..\n")

cat("\nUpdating committee data import dates\n")
system(command="sudo ./adjustUpdateCommitteeScrapeDates.R")

cat("\nLogging db status\n")
system(command="sudo ~/hackOregonDbStatusLogger.R bulkLoadScrapedCommitteeData.R")

cat("\nBulk loading of committee data complete.\n")