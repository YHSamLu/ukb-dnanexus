# ukb-dnanexus

This repository is the project of analysis in UKBiobank, DNA nexus is utilized for analyzing for those dataset and including many tools such as vcftools for exporting "VCF" files, R studio or python, etc. The data set of annotaion such as ANNOVAR and ClinVar, DNA nexus allowed to run bash for downloading anntation of database and applications. 

## Export the vcf from UKBiobank

Jupyter notebook includes R, python, and bash in DNA nexus, bash is available to run `swiss-army-knife` which is to export every kind of information from vcf file by `vcftools`. The first step is to find the patients ID (EID) from 500K database and the location of vcf folders. For instance, EID list is (100001, 100002, 100003, 100004), the bash run loop to colloct their vcf. In fact, We know the path "Bulk/Exome sequences/Exome OQFE variant call files (VCFs)/" store vcf files of patients, and vcf file named by "EID_23141_0_0.g.vcf.gz".

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

The vcf file of patients in your cohort should be in your folder.

## Annotation (ANNOVAR)

ANNOVAR is the basic annoation database that annotate all common variables: chromesome, start position, end position, reference, alternative, etc.

```{bash}
# install annovar applications with the latest version

wget http://www.openbioinformatics.org/annovar/download/0wgxR2rIVP/annovar.latest.tar.gz
```
```{bash}
# unzip
tar xvfz annovar.latest.tar.gz
```

```{bash}
# use perl to download database of annovar
perl annovar/annotate_variation.pl -downdb -webfrom annovar -buildver hg38 humandb/
```

```{bash}
# use perl to download database of annovar
mkdir annovar_output
```

```{bash}
#!/bin/bash
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
# install annovar applications with the latest version

wget http://www.openbioinformatics.org/annovar/download/0wgxR2rIVP/annovar.latest.tar.gz
```
```{bash}
# unzip
tar xvfz annovar.latest.tar.gz
```

```{bash}
# use perl to download database of clinvar in the latest version
perl annovar/annotate_variation.pl -downdb -webfrom clinvar_20250721 -buildver hg38 humandb/
```

```{bash}
mkdir clinvar_output
```

```{bash}
for eid in 100001 100002 100003 100004; do

    perl annovar/table_annovar.pl (your vcf folder)/${eid}_23141_0_0.g.vcf.gz humandb/ -buildver hg38 -out clinvar_output/${eid} -remove -protocol clinvar_20250721 -operation f -nastring . -vcfinput

    rm -rf clinvar_output/${eid}.avinput
    rm -rf clinvar_output/${eid}.hg38_multianno.vcf
    rm -rf clinvar_output/${eid}.invalid_input
done
```