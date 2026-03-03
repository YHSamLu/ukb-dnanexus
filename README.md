# ukb-dnanexus

This repository contains analysis projects for UK Biobank data. DNA Nexus is used to process these datasets with tools such as vcftools for exporting VCF files, RStudio, Python, and others. Annotation datasets (e.g., ANNOVAR and ClinVar) are integrated via bash scripts run in DNA Nexus to download databases and applications.

## Export the vcf from UKBiobank

Jupyter notebooks in DNA Nexus support R, Python, and bash kernels. Bash enables running `swiss-army-knife` (via vcftools) to extract various information from VCF files.

The first step identifies patient IDs (EIDs) from the 500K database and locates the corresponding VCF folders. For example, given an EID list like (100001, 100002, 100003, 100004), a bash loop collects their VCFs. These files are stored in the path `Bulk/Exome sequences/Exome OQFE variant call files (VCFs)/` and named as `EID_23141_0_0.g.vcf.gz`.

```{bash}
#!/bin/bash

for eid in 100001 100002 100003 100004; do

  dx run swiss-army-knife \
    -iin="Bulk/Exome\ sequences/Exome\ OQFE\ variant\ call\ files\ (VCFs)/${eid}_23141_0_0.g.vcf.gz" \
    -icmd="vcftools --gzvcf * --recode --recode-INFO-all --out ${eid}" \
    --destination="(your folder)/" \
    --instance-type="mem1_ssd2_v2_x4" \
    --yes

done
```

This simple bash script uses a for loop—the most straightforward approach—to process multiple VCF files. The `dx` command, central to DNA Nexus, runs `swiss-army-knife` tools like `vcftools` to extract and recode VCFs from UK Biobank folders.

Ensure that VCF files for patients in your cohort are stored in your project folder.

## Annotation (ANNOVAR)

ANNOVAR is a core annotation tool that annotates common variant fields, including chromosome, start position, end position, reference allele, alternate allele, and others.

```{bash}
wget http://www.openbioinformatics.org/annovar/download/0wgxR2rIVP/annovar.latest.tar.gz

tar xvfz annovar.latest.tar.gz

perl annovar/annotate_variation.pl -downdb -webfrom annovar -buildver hg38 humandb/
```

```{bash}
#!/bin/bash
mkdir annovar_output
for eid in  100001 100002 100003 100004; do

    perl annovar/table_annovar.pl (your vcf folder)/${eid}_23141_0_0.g.vcf.gz annovar/humandb/ -buildver hg38 -out annovar_output/${eid} -remove -protocol ensGene -operation g -nastring . -vcfinput


    rm -rf annovar_output/${eid}.avinput
    rm -rf annovar_output/${eid}.ensGene.invalid_input
    rm -rf annovar_output/${eid}.hg38_multianno.vcf
    echo "EID: ${eid} is finished."

done
```

## Annotation (Clinvar)

We are interest at Pathogenic and likely pathogenic (P/LP), clinvar annotates CLNSIG and other clinical related variables. 

```{bash}
wget http://www.openbioinformatics.org/annovar/download/0wgxR2rIVP/annovar.latest.tar.gz

tar xvfz annovar.latest.tar.gz

perl annovar/annotate_variation.pl -downdb -webfrom clinvar_20250721 -buildver hg38 humandb/
```

```{bash}
mkdir clinvar_output

for eid in 100001 100002 100003 100004; do

    perl annovar/table_annovar.pl (your vcf folder)/${eid}_23141_0_0.g.vcf.gz humandb/ -buildver hg38 -out clinvar_output/${eid} -remove -protocol clinvar_20250721 -operation f -nastring . -vcfinput

    rm -rf clinvar_output/${eid}.avinput
    rm -rf clinvar_output/${eid}.hg38_multianno.vcf
    rm -rf clinvar_output/${eid}.invalid_input
done
```