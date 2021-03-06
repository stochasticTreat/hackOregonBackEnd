#!/usr/bin/Rscript
setwd("~/data_infrastructure/orestar_scrape/")
source("./dbi.R")
source("runIdScraper.R")
dbname="hackoregon"
# dbname = "hack_oregon"

#get all file names
# args <- commandArgs(trailingOnly=TRUE)
# indir = args[1]
indir = "./raw_committee_data/"
# cat("Argument passed:",indir,"\n")

fnames = dir(indir)
#get dates
fdates = file.info( paste0(indir,fnames) )$mtime
#get committee ids
ids = getIdFromCommitteeScrapeFileName(fname=fnames)

tab = data.frame(id=ids, scrape_date=fdates, file_name=fnames)
#remove rows where id is null
tab = tab[!is.na(tab$id),]

cat("\n",nrow(tab),"committee scrape files found.\n")
#adjust dates in actual table

dbiWrite(tabla=tab, name="committee_import_dates", appendToTable=T, dbname=dbname)
#rebuild db

