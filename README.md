# Codes-for-lettuceTGenome
1 Analysis of DNA mehylation
1.1 The program can be used for mapping BS-seq data with PE-reads and generate reports for QC, mapping and methylation level.
#dependents
#bowtie2-2.2.9
#bismark
#fastq
usage:perl 01_bismark_for_PE_reads.pl $ARGV[0]
# $ARGV[0] indicate the name of each lines;
1.2 Merged cytosines methylated state of each accession.
usage:perl 01_merge_bismark_CG_for_population_genetics.pl 01_CG

2 RNA-seq analysis
2.1 split each rnaseq data based on the indexs
python split_fastq_for_each_tissue.py $R1 $R2 index.txt
2.2The program can be used for mapping 3RNA-seq data with single-reads and generate gene expression level.
#dependents
#bowtie2-2.2.9
#hisat2
#fastq
usage:perl 03_RNA-seq_for_gene_expression.pl $ARGV[0]

