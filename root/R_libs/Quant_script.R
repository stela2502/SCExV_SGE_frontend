library(Rsubread)

bams <- readLines("req_bams.txt")
counts <- featureCounts(files =bams,annot.ext = "/share/apps/data/genomes/mouse/mm10/mm10_Refseq.gtf",isGTFAnnotationFile = TRUE,GTF.featureType = "exon",
GTF.attrType = "gene_id",allowMultiOverlap=T, isPairedEnd = FALSE, nthreads = 32)

counts.tab <- cbind(counts$annotation,counts$counts)  # combine the annotation and counts
write.table(counts.tab, "Tina_Quants_Refseq_Apr2015_mm10_hisat.txt", row.names = F, col.names = T, quote = F, sep = "\t")

