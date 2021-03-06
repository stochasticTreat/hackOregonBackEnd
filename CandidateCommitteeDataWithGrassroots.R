#hustonStaticDumps2

source('~/prog/hack_oregon/dbi.R')


getCurrentCycleCCtrasactions<-function(minDate="2012-11-15", numCommittees=10){
	
	q1 = paste0("select * 
			from raw_committee_transactions 
			where filer_id in 
				(select filer_id
					from raw_committee_transactions 
					join raw_committees
					on filer_id = committee_id
					where tran_date > '",minDate,"'
					and committee_type = 'CC'
					and direction = 'in'
					group by filer_id
					order by sum(amount) desc
					limit ",numCommittees,")
			and  tran_date > '",minDate,"'
			and direction ='in'")
	dbres = dbiRead(query=q1, dbname="hack_oregon")
	return(dbres)
}

#'@title Display distributions of contribution amounts. 
#'@description Makes two histograms of contribution amounts, one normal scale, and one log scale. Outputs to screen or file.
#'@param ctran The data frame returned by getCurrentCycleCCtrasactions. Essentially just a subset of the transactions table.
#'@param fname Optional; if provided, the plot will be output to a file. If omitted, the program will attempt to output the plot to the screen.
displayDistContAmount<-function(ctran, fname=NULL){
	require(ggplot2)
	require(gridExtra)
	
	p1 = ggplot(data=ctran, aes(x=amount))+
		geom_histogram(binwidth=50)+
		xlab(label="Amount contributed ($)")+
		ylab("Number of contributions")+
		ggtitle("Distribution of individual contribution amounts")
	
	p2 = ggplot(data=ctran, aes(x=amount))+
		geom_histogram()+
		xlab(label="Amount contributed ($, log scale)")+
		ylab("Number of contributions")+
		ggtitle("Distribution of individual contribution amounts\nlog scale")+
		scale_x_log10(breaks=(10^(0:10)))+
		annotation_logticks(sides="b")
	
	if(is.null(fname)){
		grid.arrange(p1,p2, nrow=2)
	}else{
		ggsave(filename=fname, plot=arrangeGrob(p1,p2))
	}

}

addGrassRootCutCol<-function(ctran){
	
	grassRoots = rep("no", time=nrow(ctran))
	grassRoots[ctran$amount<200] = "yes"
	out  = cbind.data.frame(ctran,grassRoots)
	return(out)
}

getGrassState<-function(ctran){
	
	ctran = addGrassRootCutCol(ctran=ctran)
	# cand = unique(ctran$filer_id)[1]
	candidates = unique(ctran$filer_id)
	percent_grassroots = c()#rep(0,times=length(candidates))
	percent_instate = c()
	for(cand in candidates){
		cur = ctran[ctran$filer_id==cand,]
		#get percent grassroots
		cp = sum(cur$amount[cur$grassRoots=="yes"])/sum(cur$amount)
		percent_grassroots = c(percent_grassroots, cp)
		#get percent from instate
		pst = sum(cur$amount[ cur$state=="OR" ], na.rm=T)/sum(cur$amount)
		percent_instate = c(percent_instate,pst)
	}
	out = cbind.data.frame(candidates, percent_grassroots, percent_instate)
	return(out)
}


exeGetCommitteeStatsIncGrass<-function(minDate="2012-11-15",numCommittees=10000){
	
	ctran = getCurrentCycleCCtrasactions(numCommittees=numCommittees, minDate=minDate)
	
	grassSum = getGrassState(ctran=ctran)
	
	candIds = unique(ctran[,c("filer","filer_id")])
	
	candIds = candIds[!duplicated(candIds$filer_id),]
	
	grassSum = merge(x=candIds, grassSum, by.x="filer_id",by.y="candidates")
	return(grassSum)
}


comSumWithGrass = exeGetCommitteeStatsIncGrass()

dbiWrite(tabla=comSumWithGrass, name="cc_grass_roots_in_state",append=F,dbname="hack_oregon")


allTransactionsWithGrass = exeGetCommitteeStatsIncGrass(minDate="2000-1-1")


displayDistContAmount(ctran=ctran,fname="./distributionOfContributionAmounts.png")

write.table(file="./staticDump2GrassState.txt", x=grassSum, row.names=F, col.names=T, sep="\t")

q2 = "select * from comms where \"Committee_Type\"='CC'"
committees = dbiRead(query=q2, dbname="contributions")
colnames(committees)
excom = committees[committees$Committee_Id%in%grassSum$candidates,c("Committee_Id","Committee_Name","Candidate_Office","Candidate_Office_Group")]
distinctOffice = unique(excom[,c("Candidate_Office","Candidate_Office_Group")])

subtypeag = aggregate(x=ctran$amount, by=list(ctran$sub_type), FUN=sum)

ggplot(data=ctran, aes(x=sub_type, y=amount)) +
	geom_bar(stat="identity") +
	coord_flip()






