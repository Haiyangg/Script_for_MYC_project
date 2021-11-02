
#PBS -N H3K27ac_CRPC
#PBS -l nodes=fat01:ppn=10
#PBS -l walltime=72:00:00
#PBS -q all
#PBS -V
#PBS -S /bin/bash

cd /home/group1/shared_data/add_macs_result/k27ac_CRPC
merge_bigwig.sh -g 200 H3K27ac_CRPC_MEAN.bw ./chromInfo_hg19.txt *.bw

#This command was used to merge and normalize mutiple bigWig files to one.
#The file merge_bigwig.sh can be downloaded at http://wresch.github.io/2014/01/31/merge-bigwig-files.html
#The file chromInfo_hg19.txt can be downloaded at https://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/