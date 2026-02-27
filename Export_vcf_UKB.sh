#!/bin/bash

for eid in 100001 100002 100003 100004; do

  dx run swiss-army-knife \
    -iin="Bulk/Exome\ sequences/Exome\ OQFE\ variant\ call\ files\ (VCFs)/${eid}_23141_0_0.g.vcf.gz" \
    -icmd="vcftools --gzvcf * --recode --recode-INFO-all --out ${eid}" \
    --destination="(your folder)/" \
    --instance-type="mem1_ssd2_v2_x4" \
    --yes

done