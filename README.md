# A comprehensive investigation of genomic variants with likely functional impact in Prostate Cancer

---

## Table of Contents

- [Description](#description)
- [How To Use](#how-to-use)
- [Required Programs](#required-programs)
- [Author Info](#author-info)

---

### Description
Our pipeline utilized Prostate cancer related GWAS SNPs from GWAS Catalog [REF], somatic point mutations and copy number variations from ICGC consortia [13]. We then applied two different strategies that show in Supplementary figure S1 to detect hotspot regions from somatic mutation and copy number variation. These genomic variants (hotspot somatic mutation, CNVRs, and SNP) are then investigated to know the exact position of these genomic variants in the human genome. In the next step, our method integrates Hi-C data with enhancer mark (H3k27ac) to detect variants that are more likely to be regulatory variants. Finally, whole-genome sequencing of prostate cell lines can be used to approve the last genomic variants and report a list of functional variants.

---

## How To Use

**Step 1: Identification of Hotspot regions** 

**A. Hotspot somatic mutation:**

**Input file:**

*Mutations:*

Mutation files contain all somatic mutations in the study in text format. text file should be tab delimited with the following 6 columns:
 1. Chromosome
 2. Start position (1-based)
 3. End position (1-based)
 4. Reference allele
 5. Alternate allele
 6. Sample ID

Example text file:
| Chr | start | End | Ref | Alt | ID |
| --- | ----- | --- | --- | --- | -- | 
| 13 | 109318342 | 109318342	| G | A | SA328537 |

**Output files:**

For each chromosome, two CSV file in the below format are generated:

| Chr | start | End | Ref | Alt | ID | WindowNumber | #Sample |
| --- | ----- | --- | --- | --- | -- | ------------ | ------- |
| 13 | 109318342 | 109318342	| G | G | SA328537 | 5205635 | 1 |


| Chr | Start | End | Ref | Alt | ID | WindowNumber | #Sample | P-value |
| --- | ----- | --- | --- | --- | -- | ------------ | ------- | ------- |
| 13 | 109318342 | 109318342	| G | G | SA328537 | 5205635 | 1 | 0.1 |

Furthermore, our pipeline generates two CSV files merging the information of all chromosomes.  

**B. Copy number variation region:**
**Input file:**
*significant cnvrs:*
| Chr | Start | End | 
| --- | ----- | --- | 
| 1 | 6742281 |	6742903	|

*
| Chr | #sample | 
| --- | ----- | 
| 1 | 6742281 |	

| Chr | Start | End | Chr | Start | End | Sample-ID | 
| --- | ----- | --- | --- | ----- | --- | --------- |
| 1 | 6742281 |	6742903	|1	1	3652763	7562825	SP112877

---

## Required Programs

The SNATCNV pipeline requires the following dependencies:
2.1) python version
MATLAB software (>2012)
2.2) R version
R (>2.2.1)
RColorBrewer and ggplot2 (>2.2.1) packages

---

## Author Info

In case of queries, please email: mahdieh.labani@gmail.com

### Reference
```
Please consider citing the follow paper when you use this code.
  Title={},
  Authors={}
}
```


