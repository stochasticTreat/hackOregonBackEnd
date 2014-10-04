#!/usr/bin/Rscript
#export table to tsv
cat("This script should be run by passing the arguments:\n",
		"tablename : the name of the table to be exported\n",
		"dbname : the name of the database (defaults to 'hackoregon')",
		"\nExample:\n",
		"exportTableToTsv.R raw_committee_transactions hackoregon",
		"\nTable will be saved to a file named in this pattern:\n",
		"<tablename>.csv\n")

source("~/data_infrastructure/orestar_scrape/dbi.R")
# source("./orestar_scrape/dbi.R")

args <- commandArgs(trailingOnly=TRUE)
dbname=args[2]
tname=args[1]
#handle case where user only provides the table name
if(is.null(dbname)) dbname = "hackoregon"
if(is.na(dbname)) dbname = "hackoregon"

q1 = paste("select * from",tname,";")

res1 = dbiRead(query=q1, dbname=dbname)
fname = paste0(tname,".tsv")
cat("\nTable retreived with",nrow(res1), "rows and",ncol(res1),"columns.")
cat("\nTable being saved to file named:\n",fname,"\n. . . ")
write.csv(x=res1, file=fname, row.names=F)
cat("\nChecking that table can be re-opened..\n")
resNew = read.csv(file=fname, stringsAsFactors=F, strip.white=T)
cat("Test reopened table dimensions:",nrow(resNew),"rows by", ncol(resNew),"\n")


cat("done.\n")

