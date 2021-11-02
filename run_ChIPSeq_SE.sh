#PBS -N chipseq
#PBS -l nodes=fat01:ppn=40
#PBS -l walltime=200:00:00
#PBS -q all
#PBS -V
#PBS -S /bin/bash

cd ~/anaconda3/bin/
  . ./activate

module load bowtie2
module load samtools


cd /home/group1/hguo1/work_dir               #<--------------------------------------
mkdir -p bowtie2_result

ls *gz | while read id;
do
echo $id
file=$(basename $id )
sample=${file%%.*} 
echo $sample
bowtie2 -p 40 -x /home/group1/shared_data/gtf/Homo_sapiens_hg19/Ensembl/GRCh37/Sequence/Bowtie2Index/genome -U ${sample}.fq.gz 2> ./bowtie2_result/$sample.log | samtools sort -O bam -@ 40 -o ./bowtie2_result/$sample.sort.bam
samtools index -@ 40 ./bowtie2_result/$sample.sort.bam ./bowtie2_result/$sample.sort.bam.bai  ##
samtools idxstats -@ 40 ./bowtie2_result/$sample.sort.bam >> ./bowtie2_result/$sample.stats  ## 
samtools flagstat -@ 40 ./bowtie2_result/$sample.sort.bam >> ./bowtie2_result/$sample.flagstat   ##
done 

cd /home/group1/hguo1/work_dir                 #<--------------------------------------
mkdir -p macs_result
ls /home/group1/hguo1/work_dir/bowtie2_result/*.sort.bam | uniq | while read id;      #<--------------------------------------
do
file=$(basename $id )
sample=${file%%.*} 
#echo $sample
macs2 callpeak -t $id --keep-dup=1 -g hs -B --SPMR -n ./macs_result/${sample}_SPMR 2> ./macs_result/${sample}.log
bedSort ./macs_result/${sample}_SPMR_treat_pileup.bdg ./macs_result/${sample}_SPMR_treat_pileup.bdg 
bedGraphToBigWig ./macs_result/${sample}_SPMR_treat_pileup.bdg /home/group1/shared_data/gtf/chromInfo_hg19.txt ./macs_result/${sample}_SPMR.bw 
done

conda deactivate

#This script was used for mapping ChIP-Seq fq.gz files to hg19 human genome by bowtie2 and calling peaks by macs2.
