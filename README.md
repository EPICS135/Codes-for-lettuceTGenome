# Codes-for-lettuceTGenome

#1 genome accessbly

The workflow program can be used for  genome accessbly to generate contigs and scaffolds construction, and quality control and genome annotation and m6a calling.

#2 Analysis of DNA mehylation

The program can be used for mapping BS-seq data with PE-reads and generate reports for QC, mapping and methylation level.

#dependents

#bowtie2-2.2.9

#bismark

#fastq

usage:perl 01_bismark_for_PE_reads.pl $ARGV[0]

$ARGV[0] indicate the name of each lines;

#3 RNA-seq analysis

The program can be used for mapping RNA-seq data with paired-reads and generate gene expression level.

#dependents

#bowtie2-2.2.9

#hisat2

#fastq

usage:perl 02_RNA-seq_for_gene_expression.pl $ARGV[0]


