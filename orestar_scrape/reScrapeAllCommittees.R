#!/usr/bin/Rscript
cat("\nInside reScrapeAllCommittees.R\nThis script will attempt to (re)download all committee metadata.\nThis script must be run from the /orestar_scrape/ directory.\n")
source("./finDataImport.R")
source("./dbi.R")
source("./scrapeAffiliation.R")
dbname="hackoregon"
ERRORLOGFILENAME="affiliationScrapeErrorlog.txt"
source('./runIdScraper.R')


idsInCycleQuerry = "SELECT DISTINCT filer_id FROM cc_working_transactions;"
idsInCycle = dbiRead(query=idsInCycleQuerry, dbname=dbname)[,1]

participantsInCycleQuerry = "SELECT DISTINCT contributor_payee_committee_id FROM cc_working_transactions;"
participantsInCycle = dbiRead(query=participantsInCycleQuerry, dbname=dbname)
participantsInCycle = participantsInCycle[!is.na(participantsInCycle),1]

allInCycle = unique(c(participantsInCycle, idsInCycle))


allCyclesQuerry = "SELECT distinct filer_id FROM working_transactions;"
allCyclesFilerIds = dbiRead(query=allCyclesQuerry, dbname=dbname)

allCyclesParticipantsQuerry = "SELECT distinct contributor_payee_committee_id FROM working_transactions;"
allCyclesParticipants = dbiRead(query=allCyclesParticipantsQuerry, dbname=dbname)

allCyclesIds = unique(c(allCyclesParticipants[,1], allCyclesFilerIds[,1]))
allCyclesIds = allCyclesIds[!is.na(allCyclesIds)]

allIds = unique(c(allInCycle, setdiff(allCyclesIds, allInCycle)))


comtab = getCommitteeData(comids=allIds, 
													dbname=dbname, 
													rawCommitteeDataFolder="raw_committee_data", 
													rawScrapeComTabName="raw_committees_scraped")


updateCommitteeTable(comtab=comtab, 
										 dbname=dbname, 
										 rawScrapeComTabName=rawScrapeComTabName, 
										 appendTo=F)

system(command="sudo adjustUpdateCommitteeScrapeDates.R")
