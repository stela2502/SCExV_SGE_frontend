#!/bin/bash
#$ -l mem_free=1G
#$ -S /bin/bash
#$ -M bioinformatics@med.lu.se
#$ -m eas
#$ -pe orte 1
gzip -9 /home/slang/workspace/NGS_pipeline/bin/ngs_pipeline_backend.pl
