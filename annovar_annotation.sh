wget http://www.openbioinformatics.org/annovar/download/0wgxR2rIVP/annovar.latest.tar.gz

tar xvfz annovar.latest.tar.gz

perl annovar/annotate_variation.pl -downdb -webfrom annovar clinvar_20250721 -buildver hg38 humandb/

mkdir VCF
mkdir annovar_output

for eid in  100001 100002 100003 100004; do

    perl annovar/table_annovar.pl VCF_B/${eid}_23141_0_0.g.vcf.gz annovar/humandb/ -buildver hg38 -out annovar_output/${eid} -remove -protocol ensGene -operation g -nastring . -vcfinput


    rm -rf annovar_output/${eid}.avinput
    rm -rf annovar_output/${eid}.ensGene.invalid_input
    rm -rf annovar_output/${eid}.hg38_multianno.vcf
    echo "EID: ${eid} is finished."

done
