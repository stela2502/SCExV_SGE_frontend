#!/bin/bash
#$ -l mem_free=30G
#$ -S /bin/bash
#$ -M bioinformatics@med.lu.se,Stefan.Lang@med.lu.se
#$ -m eas
#$ -pe orte 32
fastqc /home/slang/workspace/NGS_pipeline/root/users/med-sal//fastq//home/slang/workspace/NGS_pipeline/t/data/some_testA1.fq -t 32
STAR --genomeDir /share/apps/data/indicies/star/mouse/mm10/ --runThreadN 32 --readFilesIn /home/slang/workspace/NGS_pipeline/root/users/med-sal//fastq//home/slang/workspace/NGS_pipeline/t/data/some_testA1.fq /home/slang/workspace/NGS_pipeline/root/users/med-sal//fastq//home/slang/workspace/NGS_pipeline/t/data/some_testA1.2.fq
genomeCoverageBed -bg -split -ibam /home/slang/workspace/NGS_pipeline/root/users/med-sal//STAR//home/slang/workspace/NGS_pipeline/t/data/some_testA1_pairedAligned.sortedByCoord.out.bam -g /share/apps/data/genomes/mouse/mm10/mm10_chrom_sizes.txt > /home/slang/workspace/NGS_pipeline/root/users/med-sal//STAR//home/slang/workspace/NGS_pipeline/t/data/some_testA1_pairedAligned.sortedByCoord.out.sorted.bed
bedGraphToBigWig /home/slang/workspace/NGS_pipeline/root/users/med-sal//STAR//home/slang/workspace/NGS_pipeline/t/data/some_testA1_pairedAligned.sortedByCoord.out.sorted.bed /share/apps/data/genomes/mouse/mm10/mm10_chrom_sizes.txt /home/slang/workspace/NGS_pipeline/root/users/med-sal//STAR//home/slang/workspace/NGS_pipeline/t/data/some_testA1_pairedAligned.sortedByCoord.out.sorted.bw
