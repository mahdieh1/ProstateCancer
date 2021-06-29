set -e

echo "Running FastQC ..."
fastqc *.fastq*

mkdir -p results/fastqc_untrimmed_reads

cd data/untrimmed_fastq/
echo "Saving FastQC results..."
mv *.zip /results/fastqc_untrimmed_reads/
mv *.html /results/fastqc_untrimmed_reads/

cd /results/fastqc_untrimmed_reads/

echo "Unzipping..."
for filename in *.zip
    do
    unzip $filename
    done

genome=/ref_genome/GRCh37.p13_genomic.fasta
mkdir -p sam bam bcf vcf
CPU=10

for infile in *_1.fastq.gz
   do
   base=$(basename ${infile} _1.fastq.gz)
   java -jar /usr/share/Java/trimmomatic.jar PE -threads 4 ${infile} ${base}_2.fastq.gz \
                ${base}_1.trim.fastq.gz ${base}_1un.trim.fastq.gz \
                ${base}_2.trim.fastq.gz ${base}_2un.trim.fastq.gz \
                SLIDINGWINDOW:4:30  ILLUMINACLIP:/usr/share/trimmomatic/TruSeq3-PE.fa 
   done

 cd data/untrimmed_fastq
 mkdir ../trimmed_fastq
 mv *.trim* ../trimmed_fastq
 cd ../trimmed_fastq
 
for fq1 in /data/trimmed_fastq/*_1.trim.fastq
    do
    echo "working with file $fq1"
    base=$(basename $fq1 _1.trim.fastq)
    echo "base name is $base"
    #input fastq files
    fq1=/data/trimmed_fastq/${base}_1.trim.fastq
    fq2=/data/trimmed_fastq/${base}_2.trim.fastq

    # output files
    sam=/results/sam/${base}.aligned.sam
    bam=/results/bam/${base}.aligned.bam
    sorted_bam=/bam/${base}.aligned.sorted.bam
    raw_bcf=/results/bcf/${base}_raw.bcf
    variants=/results/bcf/${base}_variants.vcf
    final_variants=/vcf/${base}_final_variants.vcf 
    snp=/results/vcf/${base}_snp.vcf
	Indel=/results/vcf/${base}_Indel.vcf
	filtered_snp=/results/vcf/${base}_filtered1.vcf
	final_filtered=/results/vcf/${base}_filtered2.vcf
    #align the reads to the reference genome     
    #bwa mem -t$CPU $genome $fq1 $fq2 > $sam
    #convert the SAM file to BAM format
    samtools view -S -b $sam > $bam
    #sort the BAM file
    samtools sort -@CPU -o $sorted_bam $bam 
    #index the BAM file for display purposes
    samtools index $sorted_bam
    #calculate the read coverage of positions in the genome
    bcftools mpileup -O b -o $raw_bcf -f $genome $sorted_bam 
    #call SNPs with bcftools
    bcftools call --skip-variants indels --multiallelic-caller --variants-only -o $snp $raw_bcf
	#call Indels with bcftools
    bcftools call --skip-variants snps --multiallelic-caller --variants-only -o $Indel $raw_bcf
	#Filter and report the SNP variants in variant calling format (VCF)
	bcftools filter -e "INFO/DP <= 10" $snp > $filtered_snp
    bcftools filter -e "QUAL <= 30" $filtered_snp > /media/hrokny/Data/MahdiehLabani/pc3/results/vcf/filter/final_filtered_SRR5263239_snp.vcf
    #Filter and report the SNP variants in variant calling format (VCF)
    vcfutils.pl varFilter $variants  > $final_variants
    done