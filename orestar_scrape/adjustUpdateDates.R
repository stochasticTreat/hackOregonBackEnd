#!/usr/bin/Rscript

source("./dbi.R")
source("runIdScraper.R")
dbname="hackoregon"
# dbname = "hack_oregon"

#get all file names
indir = args[1]
# indir = "./transConvertedToTsv/successfullyImportedXlsFiles/"
cat("Argument passed:",indir,"\n")

fnames = dir(indir)
#get dates
fdates = file.info( paste0(indir,fnames) )$mtime
#get committee ids
ids = getIdFromFileName(fname=fnames)

tab = data.frame(fnames=fnames, fdates=fdates, ids=ids)
#remove rows where id is null
tab = tab[!is.na(tab$ids),]

#adjust dates in actual table
q1 = "INSERT INTO "
dbCall(sql="")
#rebuild db