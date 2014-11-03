#!/usr/bin/Rscript
#check all files for dl limit
setwd("~/data_infrastructure/orestar_scrape/")
source('./runScraper.R')

args <- commandArgs(trailingOnly=TRUE)
fromXLS=args[1]

indir="./"
destDir = "./transConvertedToTsv/"

if(is.null(fromXLS)) fromXLS="txt"
if(is.na(fromXLS)) fromXLS="txt"

if(fromXLS == "xls"){
	cat("\nLoading xls files from the current working directory..\n")
	fromXLS=TRUE
}else{
	cat("\nLoading tsv or txt files from the './transConvertedToTsv/' directory\n")
	fromXLS=FALSE
} 

if(fromXLS){
	
	converted = importAllXLSFiles(remEscapes=T,
																grepPattern="^[0-9]+(-)[0-9]+(-)[0-9]+(_)[0-9]+(-)[0-9]+(-)[0-9]+(.xls)$",
																remQuotes=T,
																forceImport=T,
																indir=indir,
																destDir=destDir)
	
}

fileDir = destDir
converted = dir(fileDir)
converted = converted[grepl(pattern=".txt$|.tsv$", x=converted)]
converted = paste0(fileDir, converted)
checkHandleDlLimit(converted=converted)

tranTableName="raw_committee_transactions"
dbname="hackoregon"
transactionsFolder="./transConvertedToTsv/"
scrapedTransactionsToDatabase(tsvFolder=transactionsFolder, 
															tableName=tranTableName, 
															dbname=dbname)
