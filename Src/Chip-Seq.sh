genome=/ref_genome/GRCh37.p13_genomic.fasta
CPU=10
bwa mem -t$CPU $genome SRR1282230.fq > SRR1282230.sam
samtools view -S -b SRR1282230.sam > SRR1282230.bam      
samtools sort -@CPU -o SRR1282230_sorted_bam.bam SRR1282230.bam
samtools index SRR1282230_sorted_bam.bam
 
macs2 callpeak -t SRR1282230_sorted_bam.bam -f BAM -g hs  -n file1_label -p 1e-3 


