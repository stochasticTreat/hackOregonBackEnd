#!/usr/bin/Rscript
source("./orestar_scrape/productionCandidateCommitteeDataWithGrassroots.R")
source("./orestar_scrape/dbi.R")
DBNAME="hackoregon"
#these all go in buildEndpointTables.sh
# system("sudo -u postgres psql hackoregon < ")
#make cc_grass_roots_in_state
comSumWithGrass = exeGetCommitteeStatsIncGrass(dbname=DBNAME)#current cycle grass and in state
dbiWrite(tabla=comSumWithGrass, name="cc_grass_roots_in_state",append=F,dbname=DBNAME)
allTransactionsWithGrass = exeGetCommitteeStatsIncGrass(minDate="2000-1-1", dbname=DBNAME)#all cycles grass and in state
dbiWrite(tabla=allTransactionsWithGrass, name="ac_grass_roots_in_state",append=F,dbname=DBNAME)
