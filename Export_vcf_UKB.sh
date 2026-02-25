#!/bin/bash

for eid in 100001 100002 100003 100004; do
  pre="${eid:0:1}"
  prefix="${eid:0:2}"
  echo "EID: ${eid}"

  dx run swiss-army-knife \
    -iin="Bulk/Exome\ sequences/Exome\ OQFE\ variant\ call\ files\ (VCFs)/${prefix}/${eid}_23141_0_0.g.vcf.gz" \
    -icmd="vcftools --gzvcf * --recode --recode-INFO-all --out ${eid}" \
    --destination="ysl26/ANNO/Whole_Geno/A/${pre}" \
    --instance-type="mem1_ssd2_v2_x4" \
    --yes

done
