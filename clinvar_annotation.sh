wget http://www.openbioinformatics.org/annovar/download/0wgxR2rIVP/annovar.latest.tar.gz

tar xvfz annovar.latest.tar.gz

perl annovar/annotate_variation.pl -downdb -webfrom annovar clinvar_20250721 -buildver hg38 humandb/

mkdir VCF
mkdir clinvar_output

for eid in 100001 100002 100003 100004; do
    pre="${eid:0:2}"
    dx download "Bulk/Exome\ sequences/Exome\ OQFE\ variant\ call\ files\ (VCFs)/${pre}/${eid}_23141_0_0.g.vcf.gz" -r -o VCF

    perl annovar/table_annovar.pl VCF/${eid}_23141_0_0.g.vcf.gz humandb/ -buildver hg38 -out clinvar_output/${eid} -remove -protocol clinvar_20250721 -operation f -nastring . -vcfinput

    rm -rf clinvar_output/${eid}.avinput
    rm -rf clinvar_output/${eid}.hg38_multianno.vcf
    rm -rf clinvar_output/${eid}.invalid_input
    rm -rf VCF/${eid}_23141_0_0.g.vcf.gz
done

zip clinvar_output.zip clinvar_output
