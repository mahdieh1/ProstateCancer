# A comprehensive investigation of genomic variants with likely functional impact in Prostate Cancer

---

## Table of Contents

- [Description](#description)
- [How To Use](#how-to-use)
- [Author Info](#author-info)

---

### Description
Our pipeline utilized Prostate cancer related GWAS SNPs from GWAS Catalog [REF], somatic point mutations and copy number variations from ICGC consortia [13]. We then applied two different strategies that show in Supplementary figure S1 to detect hotspot regions from somatic mutation and copy number variation. These genomic variants (hotspot somatic mutation, CNVRs, and SNP) are then investigated to know the exact position of these genomic variants in the human genome. In the next step, our method integrates Hi-C data with enhancer mark (H3k27ac) to detect variants that are more likely to be regulatory variants. Finally, whole-genome sequencing of prostate cell lines can be used to approve the last genomic variants and report a list of functional variants.

---

## How To Use

**Step 1: Identification of Hotspot regions** 

**A. Hotspot somatic mutation(script Window-analysis):**

#### Input file: ####

1. Somatic Mutations:

Mutation files contain all somatic mutations in the study in text format. text file should be tab delimited with the following 6 columns:
      1. Chr: Chromosome information of Somatic mutation
      2. Start: starting position of Somatic mutation
      3. End: Ending position of Somatic mutation
      4. Ref: Reference allele
      5. Alt: Alternate allele
      6. ID: Sample ID

Example text file:
| Chr | start | End | Ref | Alt | ID |
| --- | ----- | --- | --- | --- | -- | 
| 13 | 109318342 | 109318342	| G | A | SA328537 |

#### Output files: ####

For each chromosome, two CSV file in the below format are generated:

| Chr | start | End | Ref | Alt | ID | WindowNumber | #Sample |
| --- | ----- | --- | --- | --- | -- | ------------ | ------- |
| 13 | 109318342 | 109318342	| G | G | SA328537 | 5205635 | 1 |


| Chr | Start | End | Ref | Alt | ID | WindowNumber | #Sample | P-value |
| --- | ----- | --- | --- | --- | -- | ------------ | ------- | ------- |
| 13 | 109318342 | 109318342	| G | G | SA328537 | 5205635 | 1 | 0.1 |

Furthermore, our pipeline generates two CSV files merging the information of all chromosomes.  

#### Setting argument: ####

length_window: 21

   can be set by other window length such as 9,50,5000bp
   
**B. Copy number variation region:**

#### Input files: ####

In order to process the CNV dataset, our pipleine requires two files as following: 

1. significant cnvrs:

| Chr | Start | End | 
| --- | ----- | --- | 
| 1 | 6742281 | 6742903 |

2. Number: contains the number of samples in each cnvrs

| Chr | #Sample | Start | End | 
| --- | ------- | ----- | --- | 
| 1 | 15 | 6742281 | 6742903 |	

3. intersect: list of interscted cnvrs with cnvs 

| Chr | Start | End | Chr | Start | End | Sample-ID | 
| --- | ----- | --- | --- | ----- | --- | --------- |
| 1 | 6742281 | 6742903	| 1 |	3652763 | 7562825 | SP112877 |

#### Output file: ####

Selected cnvrs:

| ID | #sample | start | Cluster-NO | Score | result(0/1) | 
| -- | ------- | ----- | ---------- | ----- | --- | 
| chr1:16543346-16577163 | 21 | 16543346 | 1 |	225.86 | 0 |
 
---
**Step 2: Determining Functional variants** 
2.1.WGS analysis
2.2.H3k27ac analysis
2.3. Hi-c analysis 




## Author Info

In case of queries, please email: mahdieh.labani@gmail.com

### Reference
```
Please consider citing the follow paper when you use this code.
  Title={},
  Authors={}
}
```


