library(DESeq) 
library("biomaRt")
library(gplots)
library(RSvgDevice)
library(Cairo)
library(Rsubread)
library(stringr)


read.bams <- function ( bamFiles, annotation, GTF.featureType='exon', GTF.attrType = "gene_id", isPairedEnd = FALSE, nthreads = 32){
	if (file.exists(bamFiles)){
		bamFiles <- readLines(bamFiles)
	}
	counts <- featureCounts(files =bamFiles,annot.ext = annotation ,isGTFAnnotationFile = TRUE,GTF.featureType = GTF.featureType,
		GTF.attrType = GTF.attrType,allowMultiOverlap=T, isPairedEnd =isPairedEnd , nthreads = nthreads)
	counts.tab <- cbind(counts$annotation,counts$counts)  # combine the annotation and counts
	write.table(counts.tab, "Tina_Quants_Refseq_Apr2015_mm10_hisat.txt", row.names = F, col.names = T, quote = F, sep = "\t")
	counts.tab
}

difference <- function ( x, clusters ) {
	ret = 0 
	for ( i in 1:max(clusters)  ) {
		a <- x[which( clusters == i)]
		a <- a[- (is.na(a))==F]
		if ( length(a) > 1 ) {  ret = ret + sum( (a- mean(a) )^2 ) }
	}
	ret
}

SumOfSquares.NGSexpressionSet <- function( x, phenotype ) {
	sos <- 0
	test = NULL
	if ( ! is.null(x$expr)){
		test <- x$expr
	}else{
		test <- log(exprs(x$vsdFull))
	}
	clusters <- as.numeric( x$samples[,phenotype])
	ret <- list ( 'per_expression' = apply(test,2, difference, clusters ) )
	sos <- round(sum(ret$per_expression))
	sos
}


getProbesetsFromAnnotation <- function ( x, chr=NULL, start=NULL, end=NULL  ) {
	UseMethod('getProbesetsFromAnnotation', x)
}


# getProbesetsFromStats returns a list of probesets (the rownames from the data matrix) for a restriction of a list of stat comparisons
# @param v The cutoff value
# @param pos The column in the stats tables to base the selection on
# @param Comparisons A list of comparisons to check (all if left out)
# @param mode one of 'less', 'more', 'onlyless' or 'equals' default 'less' ( <= )
# @examples 
# probes <- getProbesetsFromStats ( x, v=1e-4, pos="adj.P.Val" ) 
# returns a list of probesets that shows an adjusted p value below 1e-4

getProbesetsFromAnnotation.NGSexpressionSet <- function ( x, chr=NULL, start=NULL, end=NULL ) {
	probesets <- NULL
	ret <- rownames(x$annotation)[ x$annotation[, grep("chr", colnames(x$annotation))] ==chr & x$annotation$start < end & x$annotation$end > start]
	return ( ret )
}

reduce.Obj <- function  ( x, probeSets=c(), name="reducedSet" ) {
	UseMethod('reduce.Obj', x)
}
reduce.Obj.NGSexpressionSet <- function ( x, probeSets=c(), name="reducedSet" ) {
	retObj <- x
	retObj$data <- data.frame( x$data[match(probeSets, rownames(x$data)),] )
	rownames(retObj$data) <- probeSets
	colnames(retObj$data) <- colnames(x$data)
	retObj$genes <- probeSets
	retObj$name = name
	retObj$annotation <- x$annotation[is.na(match(x$annotation[,x$rownamescol], probeSets ))==F,]
	if ( exists( 'stats', where=retObj) ){
		for ( i in 1:length(names(retObj$stats))){
			retObj$stats[[i]]= retObj$stats[[i]][ match(probeSets ,retObj$stats[[i]][,1] ),]
		}
	}
	retObj[ match( c( 'design', 'cont.matrix', 'eset','fit', 'fit2' ), names(retObj) )] <- NULL
	retObj
}

drop.samples <-  function ( x, names, colname ){
	UseMethod('drop.samples', x)
}

drop.samples.NGSexpressionSet <-  function ( x, names=NULL, colname=NULL ){
	names = match( names,Ig_analysis$samples[, colname])
	if ( sum( is.na(names)==F ) > 0 ) {
	   x$samples <- x$samples[-names,]
	   x$data <- x$data[,-names]
	}
	x
}



getProbesetsFromStats <- function ( x, v=0.05, pos=6, mode='less', Comparisons=NULL ) {
	UseMethod('getProbesetsFromStats', x)
}

force.numeric <- function ( dataObj ) {
	for ( i in 1: ncol(dataObj$data) ) { 
		if ( !  paste(as.vector(dataObj$data[,i]), collapse=" ") == paste(as.vector(as.numeric(dataObj$data[,i])), collapse=" ") ) { 
			dataObj$data[,i] <- as.vector(as.numeric(dataObj$data[,i]))
		}
	}
	dataObj
}

groups.boxplot <- function( x, SampleCol='GroupName', clusters=NULL, svg=F, fname='group_', width=800, height=800, mar=NULL, Collapse=NULL, ... ) {
	UseMethod('groups.boxplot',x)
}

#, las=2, cex.axis=2.5, cex.main=3, lwd=2, cex.lab=2, mar=c( 6,4.1,4.1,2.1 )
groups.boxplot.NGSexpressionSet <- function( x, SampleCol='GroupName', clusters, svg=F, fname='group_', width=800, height=800,mar=NULL, Collapse=NULL, ...) {
	maxG <- max( clusters )
	ret <- list()
	r=1
	gnames <- unique(as.vector(x$samples[,SampleCol]))
	if ( ! is.null( Collapse) ){
		x <- collaps( x, what = Collapse )
		fname = paste( fname, Collapse,"_",sep='')
	}
	x <- z.score(x)
	fnames <- vector('character', maxG )
	ma = -100
	mi = +100
	for ( i in 1:maxG ){
		if ( svg ) {
			fnames[i] = paste(x$outpath,fname,i,"_boxplot.C.svg",sep='')
			CairoSVG ( file= fnames[i], width=width/130, height=height/130 )
		}else{
			fnames[i] =paste(x$outpath,fname,i,"_boxplot.png",sep='')
			png( file=fnames[i],width=width,height=height )
		}
		
		robj <- reduce.Obj( x, names(clusters)[which(clusters==i)], name=paste("group_",i,sep='') )
		
		ret[[r]] <- rownames(robj$data)
		r = r+1
		names(ret)[length(ret)] = robj$name
		a= 1;
		d <- list()
		for ( n in gnames ){
			d[[a]] = as.vector(unlist(robj$data[,which(robj$samples[,SampleCol] == n)]))
			a = a+1
		}
		names(d) <- gnames
		A <- NULL
		if ( ! is.null(mar) ){
			A <- boxplot(d, main=paste('Cluster', i, ' - ',nrow(robj$data)," genes", sep='' ),outline=FALSE, par(mar=mar), ...  )
		}else {
			A <- boxplot(d, main=paste('Cluster', i, ' - ',nrow(robj$data)," genes", sep='' ),outline=FALSE, ...  )
		}
		mi <- min(c(mi,A$stats[1,]))
		ma <- max(c(ma, A$stats[5,]))
		dev.off()
	}
	print ( paste(  "min",mi, 'max', ma) )
	#print (paste('montage', paste(fnames, collapse= " "), "-geometry", paste("'", width, "x", height,"+0+0'",sep=''),paste(x$outpath,fname,"montage.png",sep=''), sep=' ' ))
	try( file.remove(  paste(x$outpath,fname,"montage.png",sep='') ) , silent=T )
	system ( paste('montage', fnames, "-geometry", paste("'", width, "x", height,"+0+0'",sep=''),paste(x$outpath,fname,"montage.png",sep='')," 2>/dev/null", collapse=' ' ) )
	ret
}

## obtained from https://stackoverflow.com/questions/8261590/write-list-to-a-text-file-preserving-names-r
write.list <- function( x, fname, sep=' ') {
	z <- deparse(substitute(x))
	cat(z, "\n", file=fname)
	nams=names(x) 
	for (i in seq_along(x) ){ cat(nams[i], sep,  x[[i]], "\n", 
				file=fname, append=TRUE) 
	}
}

# normalizeReads.NGSexpressionSet <- function ( x, readCounts  )
# @param x The NGSexpressionSet
# @param readCounts The number of reads from each bam file

normalizeReads <- function  ( x, readCounts=NULL, to_gene_length=FALSE, geneLengthCol='transcriptLength') {
	UseMethod('normalizeReads', x)
}

normalizeReads.NGSexpressionSet <- function (  x, readCounts=NULL, to_gene_length=FALSE, geneLengthCol='transcriptLength' ) {
	if ( is.null( readCounts ) ) {
		readCounts <- as.vector( estimateSizeFactorsForMatrix ( x$data) )
	}
	x$samples$SizeFactor <- readCounts
	if (! exists('normalized', where=x ) ) {
		x$normalized = 0
	}
	if ( x$normalized == 0 ) {
		x$raw <- x$data
		x$data =  t(apply(x$data,1, function(a) { a / readCounts } ) )
		x$normalized = 1
	}
	if (to_gene_length){
		for ( i in 1:nrow(x$data)) {
			x$data[i,] <- x$data[i,]/ (x$annotation[i,geneLengthCol ] / 1000)
		}
	}
	x
}

# getProbesetsFromStats returns a list of probesets (the rownames from the data matrix) for a restriction of a list of stat comparisons
# @param v The cutoff value
# @param pos The column in the stats tables to base the selection on
# @param Comparisons A list of comparisons to check (all if left out)
# @param mode one of 'less', 'more', 'onlyless' or 'equals' default 'less' ( <= )
# @examples 
# probes <- getProbesetsFromStats ( x, v=1e-4, pos="adj.P.Val" ) 
# returns a list of probesets that shows an adjusted p value below 1e-4

getProbesetsFromStats.NGSexpressionSet <- function ( x, v=0.05, pos=6, mode='less', Comparisons=NULL ) {
	if ( is.null(Comparisons)){	Comparisons <- names(x$toptabs) }
	probesets <- NULL
	for ( i in match(Comparisons, names(x$toptabs) ) ) {
		switch( mode,
				'less' = probesets <- c( probesets, as.vector(x$toptabs[[i]][which(x$toptabs[[i]][,pos] <= v),1] )),
				'more' = probesets <- c( probesets, as.vector(x$toptabs[[i]][which(x$toptabs[[i]][,pos] > v),1] )), 
				'onlyless' = probesets <- c( probesets, as.vector(x$toptabs[[i]][which(x$toptabs[[i]][,pos] < v),1] )),
				'equals' = probesets <- c( probesets, as.vector(x$toptabs[[i]][which(x$toptabs[[i]][,pos] == v),1] ))
		)
	}
	unique(probesets)
}

getProbesetsFromValues <- function ( x, v='NULL', sample='NULL', mode='less' ){
	UseMethod('getProbesetsFromValues', x)
}


# Select probesets, that show a certain level in expression for a single sample
# @param v The cutoff value
# @param sample The sample name
# @param mode one of 'less', 'more', 'onlyless' or 'equals' default 'less' ( <= )
# @examples 
# probes <- getProbesetsFromStats ( x, v=10, sample="A" ) 
# returns a list of probesets that has a expression less than 10 in sample A

getProbesetsFromValues.NGSexpressionSet <- function ( x, v='NULL', sample='NULL', mode='less' ){
	s <- FALSE
	if ( is.null(v) ){
		s<-TRUE
	}
	if ( is.null(sample) ){
		s<-TRUE
	}
	if ( s ) { stop ( "Please give me the required values for v and sample") }
	probesets <- NULL
	for ( s in sample ) {
	switch( mode,
			'less' = probesets <- c(probesets, as.vector(rownames(x$data)[which(x$data[,s] <= v)] ) ) ,
			'more' = probesets <- c(probesets, as.vector(rownames(x$data)[which(x$data[,s] > v)] ) ), 
			'onlyless' = probesets <- c(probesets,  as.vector(rownames(x$data)[which(x$data[,s] < v)] ) ),
			'equals' = probesets <- c(probesets, as.vector(rownames(x$data)[which(x$data[,s] == v)] ) )
	)
	}
	unique(probesets)
}

subset.NGSexpressionSet <- function( x, column='Analysis', value=NULL, name='newSet', usecol='Use' ){
	S <- x$samples[which ( x$samples[, column] == value & x$samples[, usecol] == 1 ),]
	x$data <- x$data[, as.vector(S[, 'SampleName' ])]
	x$data <- x$data[, order(S$Order)  ]
	x$samples <- S
	x$name <- name
	if ( exists(where=x, 'vsdFull')){
		x$vsdFull <- NULL
		x$cds <- NULL
	}
	if ( exists(where=x, 'stats')){
		x$stats <- NULL
	}
	if ( exists(where=x, 'sig_genes')){
		x$sig_genes <- NULL
	}
	colnames(x$data) <- forceAbsoluteUniqueSample ( as.vector(S[, x$sampleNamesCol ]) )
	x$samples[,'SampleName'] <- colnames(x$data)
	write.table (S, file=paste(name,'_Sample_Description', ".xls", sep=''), sep='\t',  row.names=F,quote=F )
	x
}

createWorkingSet <- function ( dat, Samples,  Analysis = NULL, name='WorkingSet', namecol='GroupName', namerow= 'GeneID', usecol='Use' , outpath = NULL) {
	S <- Samples
	if ( ! is.null(Analysis) ){
		S <- Samples[which ( Samples$Analysis == Analysis ), ]
	}
	if ( ! is.null(usecol) ) {
		S <- Samples[which ( Samples[, usecol] == 1 ),]
	}
	if ( exists('filename',S) ) {
		ret <- dat[, as.vector(S$filename) ]
		annotation <- dat[, is.na(match( colnames(dat), as.vector(S$filename) ))==T ]
	}else{
		ret <- dat[, as.vector(S[,namecol]) ]
		annotation <- dat[, is.na(match( colnames(dat), as.vector(S[,namecol]) ))==T ]
	}
	
	if ( exists( 'Order', S)){
		ret <- ret[, order(S$Order)  ]
		S <- S[order(S$Order), ]
	}
	
	colnames(ret) <- forceAbsoluteUniqueSample ( as.vector(S[, namecol]) )
	S$SampleName <- colnames(ret)
	if ( is.null(dim(annotation))){
		## this xcould be a problem... hope we at least have a vector
		if ( length(annotation) == nrow(ret)) {
			rownames(ret) <- annotation
		}
		else {
			stop ( "Sorry, please cbind the rownames to the expression values before creating this object!")
		}
	}else{
		rownames(ret) <- annotation[,namerow]
	}
	write.table (cbind(rownames(ret), ret ), file=paste(name, '_DataValues',".xls", sep=''), sep='\t',  row.names=F,quote=F )
	write.table (S, file=paste(name,'_Sample_Description', ".xls", sep=''), sep='\t',  row.names=F,quote=F )
	data <- list ( 'data' = data.frame(ret), samples = S, name= name, annotation = annotation, rownamescol = namerow )
	data$sampleNamesCol <- namecol
	class(data) <- 'NGSexpressionSet'
	data$batchRemoved=0
	
	if ( is.null(outpath)){
		outpath = pwd()
	}else if ( ! file.exists(outpath)){
		dir.create( outpath )
	}
	data$outpath <- outpath
	data
}


pwd <- function () {
	system( 'pwd > __pwd' )
	t <- read.delim( file = '__pwd', header=F)
	t <- as.vector(t[1,1])
	t <- paste(t,"/",sep='')
	unlink( '__pwd')
	t
}

print.NGSexpressionSet <- function (x) {
	cat (paste("An object of class", class(x)),"\n" )
	cat("named ",x$name,"\n")
	cat (paste( 'with',nrow(x$data),'genes and', ncol(x$data),' samples.'),"\n")
	cat (paste("Annotation datasets (",paste(dim(x$annotation),collapse=','),"): '",paste( colnames(x$annotation ), collapse="', '"),"'  ",sep='' ),"\n")
	cat (paste("Sample annotation (",paste(dim(x$samples),collapse=','),"): '",paste( colnames(x$samples ), collapse="', '"),"'  ",sep='' ),"\n")
	if ( exists(where=x, 'vsdFull')){
		cat ( "expression values are preprocessed\n" )
	}
	if ( exists(where=x, 'stats')){
		cat ( "P values were calculated for ", length(names(x$stats)) -1, " condition(s)\n")
	}
	if ( exists(where=x, 'sig_genes')){
		cat ( "significant genes were accessed for ", length(names(x$sig_genes)), " p value(s)\n")
		cat ( paste( names(x$sig_genes)),"\n")
	}
}

# mart is a data table coming from a a call like
# mart <- getBM ( attributes=c('refseq_mrna',  'ensembl_gene_id', 'mgi_symbol' ), filters='refseq_mrna', values=dat[,1], mart=ensembl )

addAnnotation <- function(x ,mart, mart.col='refseq_mrna' ) {
	UseMethod('addAnnotation', x)
}

addAnnotation.NGSexpressionSet <- function(x ,mart, mart.col='refseq_mrna'){
	if ( ! class(mart) == 'data.frame' ){
		x$annotation <- cbind(x$annotation, mart[match(rownames(x$data),mart[,mart.col] ), ] )
	}
	else {
		x$annotation <- mart[is.na(match(mart[,mart.col], rownames(x$data)))==F,]
		rownames(x$annotation) <- rownames(x$data)
	}
	x
}

forceAbsoluteUniqueSample <- function ( x ,separator='_') {
	last = ''
	ret <- vector(length=length(x))
	
	for ( i in 1:length(x) ){
		if ( is.null(ret) ){
			last = x[i]
			ret[i] <- last
		}
		else{
			last = x[i]
			if ( ! is.na(match( last, ret )) ){
				last <- paste(last,separator,sum( ! is.na(match( x[1:i], last )))-1, sep = '')
			}
			ret[i] <- last
		}
	}
	ret
}

do_comparisons.NGSexpressionSet <- function ( dataOBJ, geneNameCol= 'mgi_symbol') {
	if ( is.null(dataOBJ$stats) ){
		if ( exists(where=dataOBJ, 'vsdFull')){
			dataOBJ <- preprocess.NGSexpressionSet ( dataOBJ )
		}
		dataOBJ$stats <- list ( n = 0)
		na <- c('n')
		conditions <- as.vector(unique(dataOBJ$samples[,'GroupName']) )
		for ( i in 1:(length(conditions)-1) ){
			for ( a in (i+1):length(conditions) ){ 
				print ( paste( conditions[i], conditions[a], sep='_vs_') )
				dataOBJ$stats[[1]] = dataOBJ$stats[[1]]+1
				na[dataOBJ$stats$n+1] = paste( conditions[i], conditions[a],sep=' vs. ')
				dataOBJ$stats[[dataOBJ$stats[[1]]+1]] <- nbinomTest(dataOBJ$cds, conditions[i], conditions[a])
				write.table(
						data.frame( id = dataOBJ$stats[[dataOBJ$stats[[1]]+1]]$id ,
								GeneSymbol = as.vector (dataOBJ$annotation[is.na(match ( dataOBJ$annotation$GeneID, dataOBJ$stats[[dataOBJ$stats[[1]]+1]]$id ) ) == F, geneNameCol]), 
								dataOBJ$stats[[dataOBJ$stats[[1]]+1]][,-1] ), 
						file= paste( 'all_stats_', dataOBJ$name, na[dataOBJ$stats$n+1], '.xls',sep=''), 
						row.names=F, 
						sep="\t",
						quote=F 
				)
				dataOBJ$stats[[dataOBJ$stats[[1]]+1]] <- dataOBJ$stats[[dataOBJ$stats[[1]]+1]][which(dataOBJ$stats[[dataOBJ$stats[[1]]+1]]$padj < 0.2),] ## drop useless data
			}
		}
		names(dataOBJ$stats) <- na
	}
	dataOBJ
}

name_4_IDs.NGSexpressionSet <- function ( x, ids=NULL, geneNameCol='mgi_symbol' ) {
	if ( is.null(ids) ) {
		ids <- as.vector(colnames(x$data) )
	}
	as.vector(x$annotation[match( ids,x$annotation[, x$rownamescol]),geneNameCol])
}

get_gene_list.NGSexpressionSet <- function (x, p_value = c ( 0.1,  1e-2 ,1e-3,1e-4,1e-5, 1e-6, 1e-7, 1e-8 ), geneNameCol='mgi_symbol' ) {
	if ( exists(where=x, 'stats')){
		cmps <- names(x$stats)
		p_value <- as.numeric( p_value )
		x$sig_genes <- vector ('list', length(p_value))
		names( x$sig_genes ) <- as.vector(p_value)
		for ( p in 1:length(p_value)){
			x$sig_genes[[p]] <- vector ('list', length(cmps)-1)
			for ( i in 2:length(cmps) ){
				sig.genes <- x$stats[[i]][which(x$stats[[i]]$padj < p_value[p] ), ] 
				sig.names <- name_4_IDs.NGSexpressionSet( x, sig.genes[,1], geneNameCol)
				sig.tab <- cbind(sig.names,sig.genes ) 
				if ( ncol(sig.tab) > 0 ){
					write.table(sig.tab,paste(x$outpath,x$name,'_',cmps[i],p_value[p] ,".xls",sep=''),col.names=T,row.names=F,sep="\t",quote=F)
				}
				x$sig_genes[[p]][[i-1]] = list (id = sig.genes[,1], names=sig.names )
			}
			x$sig_genes[[p]]$all <- list( id = unique(unlist(lapply (x$sig_genes[[p]] , function(a) { a$id } ))), names= unique(unlist(lapply ( x$sig_genes[[p]], function(a) { a$names } ))) )
		}
	}
	x
}

plot.NGSexpressionSet <- function ( x, pvalue=c( 0.1,1e-2 ,1e-3,1e-4,1e-5, 1e-6, 1e-7, 1e-8 ), Subset=NULL , Subset.name= NULL, comp=NULL, gene_centered=F, collaps=NULL,geneNameCol= "mgi_symbol") {
	if ( !is.null(comp) ){
		print ("At the moment it is not possible to reduce the plotting to one comparison only" )
		return (x)
	}
	add = ''
	orig.name = x$name
	if ( gene_centered ) {
		add = 'GenesOnly'
	}
	#browser()
	if ( ! is.null(collaps)){
		if ( nchar(add) > 1 ){
			add = paste( 'mean', add, sep='_')
		}else{
			add = 'mean'
		}
	}
	if ( ! is.null(Subset) ){
		if ( is.null(Subset.name)){
			Subset.name = 'subset_name_unset'
		}
		if ( nchar(add) > 1 ){
			add = paste( add, Subset.name,sep='_')
		}else{
			add = Subset.name
		}
	}
	if ( nchar(add) > 0 ){
		x$name = paste( add,x$name, sep='_')
	}
	print ( x$name )
	for (i in match( names(x$sig_genes), pvalue ) ){
		try( plot.heatmaps( 
						x, 
						x$sig_genes[[i]],
						names(x$sig_genes)[i],
						analysis_name = paste (x$name, version), 
						gene_centered = gene_centered,
						Subset = Subset,
						collaps = collaps,
						geneNameCol= geneNameCol
		), silent=F)
	}
	x$name = orig.name
}

plot.heatmaps <- function ( dataOBJ, gene.names , pvalue=1, analysis_name ='Unnamed', gene_centered = F, Subset=NULL, collaps=NULL,geneNameCol= "mgi_symbol", pdf=F ,... ) {
	
	UseMethod('plot.heatmaps', dataOBJ)
}


plot.heatmaps.NGSexpressionSet <- function ( dataOBJ, gene.names=NULL , pvalue=1, analysis_name =NULL, gene_centered = F, Subset=NULL, collaps=NULL,geneNameCol= "mgi_symbol", pdf=F,... ) {	
	dataOBJ <- z.score( dataOBJ )

	if ( is.null(analysis_name)){
		analysis_name = dataOBJ$name
	}
	exprs = dataOBJ$data
	drop <- which( (apply(exprs,1,sd) == 0) == T)
	if ( length(drop) > 0 ){
		print ( paste("I need to drop",length(drop),"genes as the varianze is 0") )
		exprs = exprs[-drop,]
	}
	if ( ! is.null(gene.names)){
		geneNamesBased <- exprs[is.na(match(rownames(exprs),gene.names$all$id ))==F,]
		geneNamesBased <- data.frame ( 'GeneSymbol' = as.vector (dataOBJ$annotation[is.na(match ( dataOBJ$annotation$GeneID, gene.names$all$id ) ) == F, geneNameCol]),  geneNamesBased) 
	}
	else {
		geneNamesBased <- data.frame( 'GeneSymbol' = dataOBJ$annotation[rownames(exprs),geneNameCol], exprs )
	}
	if ( ! is.null(Subset) ) { ## subset is a list of srings matching to the gene symbols
		useful <- NULL
		for ( i in 1:length(Subset) ){
			useful <- c( useful, grep(Subset[i], geneNamesBased[,1] ) )
		}
		if ( length(useful) > 0 ){
			geneNamesBased <- geneNamesBased[ unique(useful), ]
		}
	}
	if ( gene_centered ){
		ok <- as.vector(which ( is.na(geneNamesBased[,1] )))
		grepped <- grep('_drop',forceAbsoluteUniqueSample(as.vector(geneNamesBased[,1]), '_drop_' ))
		if ( length(ok) > 1 ){
			geneNamesBased <- geneNamesBased[- grepped [ - match ( ok[-1] , grepped ) ], ]
		}
		else if ( length(grepped) > 0 ) {
			geneNamesBased <- geneNamesBased[-grepped, ]
		}
	}
	fname = paste(dataOBJ$outpath, 'GenesOnly_',dataOBJ$name,sep='')
	rn <- rownames(geneNamesBased)
	
	if ( ! is.null(collaps)){
		u <- unique(as.vector(dataOBJ$samples$GroupName))
		m <- length(u)
		mm <-  matrix ( rep(0,m * nrow(geneNamesBased)), ncol=m)
		colnames(mm) <- u
		rownames(mm) <- rownames(geneNamesBased)
		if ( collaps=="median") {
			for ( i in u ){
				## calculate the mean expression for each gene over all cells of the group
				mm[,i] <- apply( geneNamesBased[ , which(as.vector(dataOBJ$samples$GroupName) == i )+1],1,median)
			}
		}
		else {
			for ( i in u ){
				## calculate the mean expression for each gene over all cells of the group
				mm[,i] <- apply( geneNamesBased[ , which(as.vector(dataOBJ$samples$GroupName) == i )+1],1,mean)
			}
		}
		geneNamesBased <- data.frame( GeneSymbol = as.vector(geneNamesBased[,1]), mm )
	}else {
		collaps= ''
	}
	
	write.table( data.frame ( 'GeneSymbol' = rownames(geneNamesBased),geneNamesBased[,-1]),file= paste(fname,collaps,'_HeatmapID_',pvalue,'_data4Genesis.txt', sep=''),sep='\t', row.names=F,quote=F  )
	write.table(  geneNamesBased, file= paste(fname,collaps,'_Heatmap_GeneSymbols_',pvalue,'_data4Genesis.txt', sep=''),sep='\t', row.names=F,quote=F  )
	write.table( dataOBJ$samples, file= paste(fname,collaps,'_Sample_Description.xls', sep=''),sep='\t', row.names=F,quote=F  )
	
	if ( nrow(geneNamesBased) > 1 ){
		geneNamesBased <- data.frame(read.delim( file= paste(fname,collaps,'_Heatmap_GeneSymbols_',pvalue,'_data4Genesis.txt', sep=''), header=T ))
		rownames(geneNamesBased) <- rn
		s <- ceiling(20 * nrow(geneNamesBased)/230 )
		if ( s < 5 ) {s <- 5}
		print (paste ("Height =",s))
		if ( pdf ) {
			pdf( file=paste(dataOBJ$outpath,dataOBJ$name,collaps,"_Heatmap_IDs_",pvalue,".pdf",sep='') ,width=10,height=s)
		}else {
			devSVG( file=paste(dataOBJ$outpath,dataOBJ$name,collaps,"_Heatmap_IDs_",pvalue,".svg",sep='') ,width=10,height=s)
		}
		print ( paste ("I create the figure file ",dataOBJ$outpath,dataOBJ$name,collaps,"_Heatmap_IDs_",pvalue,".svg",sep=''))
		heatmap.2(as.matrix(geneNamesBased[,-1]), lwid = c( 1,6), lhei=c(1,5), cexRow=0.4,cexCol=0.7,col = greenred(30), trace="none", margin=c(10, 10),dendrogram="row",scale="row",
				distfun=function (x) as.dist( 1- cor(t(x), method='pearson')),Colv=F, main=paste( analysis_name, pvalue ),...)	
		dev.off()

		rownames(geneNamesBased) <- paste(geneNamesBased[,1] , rownames(geneNamesBased) )
		if ( pdf ) {
			pdf( file=paste(dataOBJ$outpath,dataOBJ$name,collaps,"_Heatmap_GeneSymbols_",pvalue,".pdf",sep='') ,width=10,height=s)
		}else{
			devSVG( file=paste(dataOBJ$outpath,dataOBJ$name,collaps,"_Heatmap_GeneSymbols_",pvalue,".svg",sep='') ,width=10,height=s)
		}
		
		print ( paste ("I create the figure file ",dataOBJ$outpath,dataOBJ$name,collaps,"_Heatmap_GeneSymbols_",pvalue,".svg",sep=''))
		heatmap.2( as.matrix(geneNamesBased[,-1]), lwid = c( 1,6), lhei=c(1,5), cexRow=0.4,cexCol=0.7,col = greenred(30), trace="none", 
				margin=c(10, 12),dendrogram="row",scale="row",distfun=function (x) as.dist( 1- cor(t(x), method='pearson'),...),
				Colv=F, main=paste( analysis_name, pvalue ))
		dev.off()
	}
	else {
		print ( "Problems - P value cutoff to stringent - no gselected genes!" );
	}
}

collaps <- function ( dataObj, what=c('median','mean','sd','sum' ) ) {
	UseMethod('collaps', dataObj)
}
collaps.NGSexpressionSet<- function(dataObj, what=c('median','mean','sd','sum' ) ) {
	u <- unique(as.vector(dataObj$samples$GroupName))
	m <- length(u)
	mm <-  matrix ( rep(0,m * nrow(dataObj$data)), ncol=m)
	colnames(mm) <- u
	rownames(mm) <- rownames(dataObj$data)
	f <- NULL
	switch( what,
			median = f<- function (x ) { median(x) },
			mean = f <- function(x) { mean(x) },
			sd = f <- function(x) { sd(x) },
			sum = f <-function(x) { sum(x)}
	);
	if ( is.null(f) ) {
		stop("Please set what to one of 'median','mean','sd','sum'" )
	}
	new_samples <- NULL
	for ( i in u ){
		all <- which(as.vector(dataObj$samples$GroupName) == i )
		new_samples <- rbind ( new_samples, dataObj$samples[all[1],] )
		mm[,i] <- apply( dataObj$data[ , all],1,f)
	}
	dataObj$name = paste( dataObj$name, what, sep='_')
	dataObj$data <- mm
	dataObj$samples <- new_samples
	dataObj
}

removeBatch.NGSexpressionSet <- function( x, phenotype ){
	if ( x$batchRemoved==1) {
		return (x)
	}
	browser()
	exprs =  dataOBJ$cds
	null <- which ( exprs == 0)
	exprs[null]<- 1
	log <- log(exprs)
	svseq <-  ComBat(dat=filtered.log , mod=mod1, batch=x$samples[,phenotype], par.prior=TRUE, prior.plots=FALSE )
	svseq <- exp(log)
	svseq[null] = 0
	x$cds <- svseq
	x$batchRemoved = 1
	x
}
	

preprocess.NGSexpressionSet <- function (x) {
	if ( ! exists(where=x, 'vsdFull')){
		condition <- as.factor(x$samples$GroupName)
		print ( condition )
		x$cds <- newCountDataSet(x$data, condition)
		x$cds <- estimateSizeFactors(x$cds) 
		sizeFactors(x$cds)
		x$cds <- estimateDispersions(x$cds) 
		x$vsdFull = varianceStabilizingTransformation( x$cds )
	}
	x
}

z.score <- function ( m ){
	UseMethod('z.score', m)
}
z.score.matrix <- function (m ) {
	rn <- rownames( m )
	me <- apply( m, 1, mean )
	sd <- apply( m, 1, sd )
	sd[which(sd==0)] <- 1e-8
	m <- (m - me) /sd
	rownames(m) <- rn
	m
}
z.score.NGSexpressionSet <- function(m) {
	#m$data <- z.score( as.matrix( m$data ))
	rn <- rownames( m$data )
	me <- apply( m$data, 1, mean )
	sd <- apply( m$data, 1, sd )
	sd[which(sd==0)] <- 1e-8
	m$data <- (m$data - me) /sd
	rownames(m$data) <- rn
	m
}


anayse_working_set <- function ( dataOBJ, name,  p_values = c ( 0.1,  1e-2 ,1e-3,1e-4,1e-5, 1e-6, 1e-7, 1e-8 ),geneNameCol= "mgi_symbol", batchCorrect=NULL)  {
	dataOBJ <- preprocess.NGSexpressionSet ( dataOBJ )
	if ( ! is.null(batchCorrect) ){
		removeBatch.NGSexpressionSet( dataOBJ ,batchCorrect )
	}
	png(file=paste(dataOBJ$name,"_",version,'_interesting_samples_clean_up.png',sep=''), width=800, height=800) 
	plot(hclust(as.dist(1-cor(dataOBJ$data))),main=paste(dataOBJ$name,version, ' samples')) 
	dev.off()
	dataOBJ <- do_comparisons.NGSexpressionSet ( dataOBJ, geneNameCol=geneNameCol)
	#dataOBJ$expr <- exprs(dataOBJ$vsdFull)
	dataOBJ <- get_gene_list.NGSexpressionSet(dataOBJ,p_values, geneNameCol=geneNameCol)	
	dataOBJ
}
simpleAnova <- function(x, samples.col='GroupName', padjMethod='BH' ) {
	UseMethod ('simpleAnova', x)
}

simpleAnova.NGSexpressionSet <- function ( x, samples.col='GroupName', padjMethod='BH' ) {
	x <- normalizeReads(x)
	significants <- apply ( x$data ,1, function(x) { anova( lm (x ~ Samples[, samples.col]))$"Pr(>F)"[1] } )
	adj.p <- p.adjust( significants, method ='BH' )
	res <- cbind(significants,adj.p )
	res <- data.frame(cbind( rownames(res), res ))
	colnames(res) <- c('genes', 'pvalue', paste('padj',padjMethod) )
	res <- list ( 'simpleAnova' = res )
	if ( exists( 'stats', where=x )) {
		x$stats <- c( x$stats, res)
	}else {
		x$stats <- res
	}
	x
}

createStats <- function(x, condition, files=F) {
	UseMethod('createStats', x)
}

createStats.NGSexpressionSet <- function (x, condition, files=F, A=NULL, B=NULL) {
	if ( nrow(x$data) < 2e+4 ) {
	    stop ( "Please calculate the statistics only for the whole dataset!" )
	}
	if ( length( grep ( condition, colnames(x$samples))) > 0 ) {
		condition = factor( x$samples[,condition] )
	}
	if ( exists( 'raw', where=x) ){
		cds <- newCountDataSet(x$raw, condition)
	}else {
		cds <- newCountDataSet(x$data, condition)
	}
	cds <- estimateSizeFactors(cds)
	# sizeFactors(cds)
	cds <- estimateDispersions(cds)
	vsdFull = varianceStabilizingTransformation( cds )
	res <- list()
	ln= 0
	na <- c()
	conditions <- as.vector(unique(condition))
	if ( ! is.null(A) && ! is.null(B)) {
		ln = ln +1
		na[ln] = paste( A, B ,sep=' vs. ')
		res[[ln]] <- nbinomTest(cds, A, B )
	}
	else {
		for ( i in 1:(length(conditions)-1) ){
			for ( a in (i+1):length(conditions) ){
				ln = ln +1
				print ( paste( conditions[i], conditions[a], sep='_vs_') )
				na[ln] = paste( conditions[i], conditions[a],sep=' vs. ')
				res[[ln]] <- nbinomTest(cds, conditions[i], conditions[a])
				#res[[ln]] <- res[[res[[1]]+1]][which(res[[res[[1]]+1]]$padj < 0.2),]
			}
		}
	}
	names(res) <- na
	if ( exists( 'stats', where=x )) {
		x$stats <- c( x$stats, res)
	}else {
		x$stats <- res
	}
	if ( files ) {
		writeStatTables( x )
	}
	x
}

export4GEDI <- function( x, fname="GEDI_output.txt", tag.col = NULL, time.col=NULL ) {
	UseMethod('export4GEDI', x)
}

export4GEDI.NGSexpressionSet <- function( x, fname="GEDI_output.txt", tag.col = NULL, time.col=NULL, minSample_PerTime=1 ) {
	if ( is.null(time.col)){
		stop ( paste( "choose time.col from:", paste( colnames(x$samples), collapse=", ") ) ) 
	}
	if ( is.null(tag.col)){
		stop ( paste( "choose tag.col from:", paste( colnames(x$samples), collapse=", ") ) ) 
	}
	groupnames <- vector('numeric', nrow(x$samples))
	for (i in 1:nrow(x$samples)) {
		groupnames[i] = paste( x$samples[i, tag.col], x$samples[i, time.col] , sep="_" )
	}
	if ( length(which(table(groupnames) > 1)) > 0 ){
		stop ( "Sorry, please calculate the mean expression for the data first ('collaps()')") 
	}
	
	treatments <- unique( as.vector(x$samples[ , tag.col] ))
	
	## now I need to find all possible days
	possible <- NULL
	for ( t in treatments ){
		possible <- c( possible, x$samples[ grep( t, x$samples[ , tag.col]) , time.col] )
	}
	required = names(which(table(possible) > minSample_PerTime) )
	passed <- NULL
	for ( t in treatments ){
		l <- rep ( -1, nrow(x$samples) )
		p <- grep( t, x$samples[ , tag.col])
		if ( length(p) >= length(required) ){
			l[p] <- x$samples[ p, time.col]
			l[ is.na(match(l, required))== T ] <- -1
			passed <- c(passed, paste( c(paste("}",t,sep=""),  l), collapse="\t") )
		}
	}
	
	fileConn<-file(fname)
	open( fileConn, "w" )
	writeLines( paste( "}Dynamic", length(passed), nrow(x$data), x$name, sep="\t"), con=fileConn)
	writeLines( paste(passed , collapse="\n") , con=fileConn )
	
	for ( i in 1:nrow(x$data) ){
		writeLines( paste( c(rownames(x$data)[i], x$data[i,]), collapse="\t" ),  con=fileConn )
	}
	
	close(fileConn)
	print( paste ("created file", fname))
}

# write.data
# @param x the NGSexpressionSet

write.data <- function ( x, annotation=NULL ) {
	UseMethod('write.data', x)
}
write.data.NGSexpressionSet <- function ( x, annotation=NULL ) {
	browser()
	if ( !is.null(annotation) ) {
		write.table( cbind( x$annotation[,annotation], x$data), file= paste( x$outpath,x$name,"_expressionValues.xls",sep=''), row.names=F, sep="\t",quote=F )
	}
	else {
		write.table( cbind( rownames(x$data), x$data), file= paste( x$outpath,x$name,"_expressionValues.xls",sep=''), row.names=F, sep="\t",quote=F )
	}
}

# export the statistic files
# @param x the NGSexpressionSet

writeStatTables <- function ( x, annotation=NULL, wData=F ) {
	UseMethod('writeStatTables', x)
}
writeStatTables.NGSexpressionSet <- function( x, annotation=NULL, wData=F ) {
	opath = paste(x$outpath,'DESeq_Pval/', sep='')
	if ( wData ) {
		opath = paste( x$outpath,'DESeq_wData/',sep='')
	}
	write.table( x$samples, file= paste(opath,'stats_Sample_Description.xls', sep=''),sep='\t', row.names=F,quote=F  )
	Comparisons <- make.names(names(x$stats))
	system ( paste('mkdir ',opath, sep='') )
	for ( i in 1:length(Comparisons )){
		fname <- paste( x$outpath,'DESeq_Pval/',Comparisons[i], '.xls',sep='')
		if ( wData==T) {
			fname <- paste( x$outpath,'DESeq_wData/',Comparisons[i], '.xls',sep='')
		}
		if ( ! is.null(annotation) ) {
			if ( wData==F ) {
				write.table( cbind( x$annotaion[, annotation],  x$stats[[i]] ) , file= fname, row.names=F, sep="\t",quote=F )
			}else {
				write.table( cbind(x$annotation[,annotation], x$stats[[i]], x$data ), file= fname, row.names=F, sep="\t",quote=F )
			}
		}
		else {
			if ( wData==F ) {
				write.table( x$stats[[i]], file= fname, row.names=F, sep="\t",quote=F )
			}else {
				write.table( cbind(x$stats[[i]], x$data ), file= fname, row.names=F, sep="\t",quote=F )
			}
		}
		print ( paste ( "table ",fname," for cmp ",Comparisons[i],"written" ) )
	}
}

describe.probeset <-  function ( x, probeset ) {
	        UseMethod('describe.probeset', x)
}
describe.probeset.NGSexpressionSet <-  function ( x, probeset ) {
	ret <- list()
	print ( paste ("Annoataion for probeset ",probeset ) )
	ret$annotation <- x$annotation[ probeset, ] 
	print ( ret$annotation )
	print ( "Values:" ) 
	ret$data <- x$data[probeset, ]
	print ( ret$data )
	ret$stats <- NULL
	#browser()
	if ( exists( 'stats', where=x) ) {
		for( i in 1:length(x$stats) ) {
	#		browser()
			ret$stats <- rbind(ret$stats, 
					   cbind ( 
						  rep(names(x$stats)[i],length(probeset) ), 
						  x$stats[[i]][is.na(match( x$stats[[i]][,1], probeset))==F,] 
						  ) 
					   ) 
		}
		colnames(ret$stats) <- c('comparison', colnames(x$stats[[1]]) )
		print ( ret$stats )
	}
	invisible(ret)
}


# getProbesetsFromStats returns a list of probesets (the rownames from the data matrix) for a restriction of a list of stat comparisons
# @param v The cutoff value
# @param pos The column in the stats tables to base the selection on
# @param Comparisons A list of comparisons to check (all if left out)
# @param mode one of 'less', 'more', 'onlyless' or 'equals' default 'less' ( <= )
# @examples 
# probes <- getProbesetsFromStats ( x, v=1e-4, pos="adj.P.Val" ) 
# returns a list of probesets that shows an adjusted p value below 1e-4

getProbesetsFromStats.NGSexpressionSet <- function ( x, v=1e-4, pos='padj', mode='less', Comparisons=NULL ) {
	if ( is.null(Comparisons)){	Comparisons <- names(x$stats) }
	probesets <- NULL
	for ( i in match(Comparisons, names(x$stats) ) ) {
		switch( mode,
				'less' = probesets <- c( probesets, as.vector(x$stats[[i]][which(x$stats[[i]][,pos] <= v),1] )),
				'more' = probesets <- c( probesets, as.vector(x$stats[[i]][which(x$stats[[i]][,pos] > v),1] )), 
				'onlyless' = probesets <- c( probesets, as.vector(x$stats[[i]][which(x$stats[[i]][,pos] < v),1] )),
				'equals' = probesets <- c( probesets, as.vector(x$stats[[i]][which(x$stats[[i]][,pos] == v),1] ))
		)
	}
	unique(probesets)
}

getProbesetsFromValues <- function ( x, v=NULL, sample=NULL, mode='less' ){
	UseMethod('getProbesetsFromValues', x)
}

# Select probesets, that show a certain level in expression for a single sample
# @param v The cutoff value
# @param sample The sample name
# @param mode one of 'less', 'more', 'onlyless' or 'equals' default 'less' ( <= )
# @examples 
# probes <- getProbesetsFromStats ( x, v=10, sample="A" ) 
# returns a list of probesets that has a expression less than 10 in sample A

getProbesetsFromValues.NGSexpressionSet <- function ( x, v=NULL, sample=NULL, mode='less' ){
	s <- FALSE
	if ( is.null(v) ){
		s<-TRUE
	}
	if ( is.null(sample) ){
		s<-TRUE
	}
	if ( s ) { stop ( "Please give me the required values for v and sample") }
	probesets <- NULL
	switch( mode,
			'less' = probesets <-  as.vector(rownames(x$data)[which(x$data[,sample] <= v)] ) ,
			'more' = probesets <- as.vector(rownames(x$data)[which(x$data[,sample] > v)] ), 
			'onlyless' = probesets <- as.vector(rownames(x$data)[which(x$data[,sample] < v)] ),
			'equals' = probesets <- as.vector(rownames(x$data)[which(x$data[,sample] == v)] )
	)
	probesets
}
