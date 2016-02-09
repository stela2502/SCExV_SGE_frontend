source('lib_RNA_Analyse.R')

#listMarts()
ensembl=useMart("ensembl")
grep( 'GRCm38.p3', listDatasets( ensembl )[,2])
# listDatasets( ensembl )[grep( 'GRCm38.p3', listDatasets( ensembl )[,2])[1],1]
# "mmusculus_gene_ensembl"
ensembl = useDataset( "mmusculus_gene_ensembl", mart=ensembl)
## or instead of useMart ... useDataset use only this line:
#ensembl = useMart("ensembl",dataset="mmusculus_gene_ensembl")

dat <- read.delim("Tina_Quants_Refseq_Apr2015_mm10_hisat.txt",header=T) 
mart <-  getBM ( attributes=c('refseq_mrna',  'ensembl_gene_id', 'mgi_symbol' ), filters='refseq_mrna', values=dat[,1], mart=ensembl )


cor.fac <- function(tab,ind){ 
	cf <- apply(tab[,ind],2,sum)/mean(apply(tab[,ind],2,sum)) 
	print(cf) 
	tab[,ind] <- t(t(tab[,ind])/cf) 
	tab 
} 
dat.cor <- cor.fac(dat,7:ncol(dat)) 

name_4_IDs <- function ( IDs, mart ) {
	as.vector(mart$mgi_symbo[match(IDs,mart$refseq_mrna)])
}

annotate.rsub.refseq <- function(ptab,mart, columns=NULL, geneIDs=NULL){ 
	ftab <-  cbind(geneIDs,name_4_IDs(ptab[,1],mart) ,ptab[,2:ncol(ptab)])
	ftab
} 


if ( file.exists('SampleDescriptions.xls') ){
	## the file has gained a column Order, Use and Analysis
	Samples <- as.data.frame ( read.delim(file='SampleDescriptions.xls', header=T ))
}else {
	Samples <- data.frame( 'filename' = colnames(dat)[7:ncol(dat)] )
	GroupName <- vector('numeric', nrow(Samples) )
	for ( i in 6:17 ) {
		GroupName[ grep(paste('P',i,sep=''),Samples$filename) ] <- paste('P',i,sep='')
	}
	Samples$GroupName <- GroupName
	write.table (Samples, file='SampleDescriptions.xls', sep='\t',  row.names=F,quote=F )
}
if ( ! is.vector(Samples$Order) ) {
	stop( "Please modify the SampleDescription.xls file and add an Order, an Use and an Analysis column.")
}

(whole_data <- createWorkingSet( dat, Samples, name='WholeSet', namecol='GroupName', namerow= 'GeneID' ))
(whole_data <- addAnnotation.NGSexpressionSet( whole_data, mart ))
(whole_data <- preprocess.NGSexpressionSet ( whole_data ))
(whole_data$samples$Test <- c (1,1,1,1,1,1,1,1,rep(0 ,37 ) ))
(test_set <- subset.NGSexpressionSet ( whole_data, column='Test', value=1))
(test_set <- preprocess.NGSexpressionSet(test_set))
(test_set <-do_comparisons.NGSexpressionSet(test_set))
(test_set <-get_gene_list.NGSexpressionSet(test_set))
test_set$sig_genes


if ( ! file.exists("Tina_Test_ALL_DATA_RawCounts.txt")){
	dat.raw.ann <- annotate.rsub.refseq(dat,mart) 
	dat.ann <- annotate.rsub.refseq(dat.cor,mart) 
	write.table(dat.raw.ann,"Tina_Test_ALL_DATA_RawCounts.txt",row.names=F,col.names=T,quote=F,sep="\t") 
	write.table(dat.ann,"Tina_Test_ALL_DATA_ScaledCounts.txt",row.names=F,col.names=T,quote=F,sep="\t") 
}

# Samples_P14.LU1.058 looks odd - remove it
Make_Sense <- c('Rag1','Rag2','Gfra1','Gfra2','Il2ra', 'Cxcr5', 'Cd200', 'Cd83', 'Cd40', 'Cd38', 'Tlr9', 'Cd2', 'Ly6d', 'Cd22', 'Ms4a1','Ly86','Bcl2', 'Slamf1','Alcam', 'Jak3', 'Soxs2', 'Lef1','Igll1',
		'Vpreb1','Vpreb2','Dntt','E2f1','Erg', 'E2f8','Kit','Hist*','Tlr4')

version = 'Version_6_2015-05-04'
name <- 'P8_to_P15'
P8_to_P15 <- subset.NGSexpressionSet ( whole_data, column='Analysis', value=1 ,name=name)
P8_to_P15 <- anayse_working_set ( P8_to_P15 , name = name )
for ( i in 1:length(names(results$sig_genes)) ){	
	try( plot.heatmaps( 
					P8_to_P15, 
					P8_to_P15$sig_genes[[i]], 
					names(P8_to_P15$sig_genes)[i], 
					analysis_name = paste ('GenesOnly',name, version), 
					gene_centered = T )
			, silent=F) 
}

name <- paste(name,'GOI',sep='_')
for ( i in 1:length(names(results$sig_genes)) ){	try( plot.heatmaps( P8_to_P15, P8_to_P15$sig_genes[[i]], names(P8_to_P15$sig_genes)[i], analysis_name = paste ('GenesOnly_GOI',name, version), gene_centered = T, Subset=Make_Sense ), silent=F) }

GOI <- c("Gfra1","Gfra2","Vpreb1","Vpreb2","Vpreb3","Tlr4","Kit","Itga5","Igll1","Gypc","Il2ra","Ccr6","Plaur","Cd22","Btla","Cd55","Cd85","Tlr1","Cd74","Cd200","Cxcr5","Tlr9","Alcam","Cd40","Ms4a1","Cd38","Fcrla","Itgb3","SlamF1","I1cam","Cd274","Il5ra","Fcgr2b","Pax5","Foxo1","Ebf1","Pou2","Lef1","Bcl2","Dntt","Rag1","Rag2","Ly86")
name <- 'GenesOnly_GOI_2_P8_to_P15'
for ( i in 1:length(names(results$sig_genes)) ){try( plot.heatmaps( P8_to_P15, P8_to_P15$sig_genes[[i]], names(P8_to_P15$sig_genes)[i], analysis_name = paste (name, version), gene_centered = T, Subset=GOI ), silent=F) }

name <- 'P8_to_P15'

save(P8_to_P15, file= paste(name,version,'.RData',sep='') )

name <-'hCD25'
hCD25 <- subset.NGSexpressionSet (  whole_data, column='Analysis', value= 2 , name )
hCD25 <- anayse_working_set ( hCD25 , name = 'hCD25' )
for ( i in 1:length(names(hCD25$sig_genes)) ){	try( plot.heatmaps( hCD25, hCD25$sig_genes[[i]], names(hCD25$sig_genes)[i], analysis_name = paste ('GenesOnly',hCD25$name, version), gene_centered = T ), silent=F) }
save(results,file= paste(name,version,'.RData',sep='') )


