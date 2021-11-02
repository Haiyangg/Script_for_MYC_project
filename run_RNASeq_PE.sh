#!/bin/bash
#PBS -N human_star
#PBS -l nodes=fat03:ppn=40
#PBS -l walltime=99:00:00
#PBS -q all
#PBS -V
#PBS -S /bin/bash

cd ~/anaconda3/bin/
  . ./activate

module load samtools

cd /home/group1/hguo1/work_dir


genomedir=/home/group1/shared_data/gtf/GRCh37/
  max_intron_size=100000
star_p=" --outSAMattributes NH HI NM MD \
          --outSAMstrandField intronMotif \
          --outSAMtype BAM Unsorted \
          --quantMode GeneCounts"

#The "sampleFile" file has only one column including the names of samples.
for i in `cat sampleFile`; do 
mkdir -p ${i}
STAR --runMode alignReads --runThreadN 30 \
--readFilesIn ${i}_1.fq.gz ${i}_2.fq.gz \   
--readFilesCommand zcat \
--genomeDir $genomedir/star_GRCh37 \
--outFileNamePrefix ${i}/${i}.${star_p} 
samtools sort -@ 40 -T ${i}.tmp \
-o ${i}/${i}.Aligned.sortedByCoord.out.bam \
${i}/${i}.Aligned.out.bam
samtools index ${i}/${i}.Aligned.sortedByCoord.out.bam
done

conda deactivate

#This script was used for mapping RNA-Seq fq.gz files to hg19 human genome to generate reads count tables.
