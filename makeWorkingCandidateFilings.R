#!/usr/bin/Rscript
cat("\nsourcing ~/data_infrastructure/orestar_scrape/productionLoadCandidateFilings.R ..\n")
setwd("~/data_infrastructure/orestar_scrape/")
source("./productionLoadCandidateFilings.R")
#make working_candidate_filings
cat("\ncalling makeWorkingCandidateFilings(dbname=\"hackoregon\")\n")
makeWorkingCandidateFilings(dbname="hackoregon")