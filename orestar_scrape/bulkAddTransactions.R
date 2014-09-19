#!/usr/bin/Rscript

#bulkAddTransactions.R

#make sure this is run from the correct directory
if(basename(getwd())!="orestar_scrape") setwd("orestar_scrape")

source("./productionLoadCandidateFilings.R")
source("./productionCandidateCommitteeDataWithGrassroots.R")
source("./runScraper.R")
DBNAME="hackoregon"

args <- commandArgs(trailingOnly=TRUE)
fname = args[1]
cat("\nAttempting to load transactions in bulk from the file\n",fname,"\n")
#import to raw tables

bulkImportTransactions(dbname="hackoregon", tablename="raw_committee_transactions", fname=fname)
#rebuild working tables

	#working tables:
	#candidate_detail
	#depends on:
		#working candidate committees
			#raw_candidate_committees
			#working_candidate_filings
		#cc_grass_roots_in_state
			#raw_committees
			#raw_committee_transactions

#make base working tables
setwd("..")
system("sudo ./buildOutDBFromRawTables.sh")
#if this is run from the hackoregonbackend dir (from the mac), buildOutDBFromRawTables.sh will be in the parent dir.
#if this is run from the data_infrastructure folder, (from an ubuntu install) buildOutDBFromRawTables.sh will
#be in the parent dir.
#make special tables


#make working_candidate_committees
	#!!! created immediately before campaign_detail, in the same SQL script
#make campaign_detail

