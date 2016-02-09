get_figures:
	rsync -v med-sal@marrow.bmc.lu.se:/home/med-sal/NAS/Sigvardsson/Tinas_Data_RNA_SEQ_B_Cells/fastq_new/HISAT_out/* ./ --exclude *.bam
put:
	rsync -v ./SampleDescriptions.xls med-sal@marrow.bmc.lu.se:/home/med-sal/NAS/Sigvardsson/Tinas_Data_RNA_SEQ_B_Cells/fastq_new/HISAT_out/
update_libs:
	rsync -v /home/slang/workspace/NGS_pipeline/root/R_libs/*.R med-sal@marrow.bmc.lu.se:/home/med-sal/NAS/Sigvardsson/Tinas_Data_RNA_SEQ_B_Cells/fastq_new/HISAT_out/
clear:
	rm *data4Genesis.txt *vs.*.xls *.svg
