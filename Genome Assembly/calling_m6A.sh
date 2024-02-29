
conda activate py3
	minimap2 -t 10 -a -x map-ont path/cdna.fa \
	path.fastq.gz | samtools sort -T tmp-ON001-RNA-R00369 -o ON001-RNA-R00369_sort.bam
	
	samtools index ON001-RNA-R00369_sort.bam

conda activate nanopolish

	nanopolish index -d path/fast5_pass/ \
	-s path/sequencing_summary_FAX30716_b1dee719_777e529e.txt \
	path.fastq.gz

	nanopolish eventalign \
	--reads path.fastq.gz \
	--bam ON001-RNA-R00369_sort.bam \
	--genome path/G259-cat-merge-utr_cdna.fa \
	--scale-events --signal-index --summary summary-ON001-RNA-R00369.txt --threads 10 > ON001-RNA-R00369_eventalign.txt

conda activate m6a
	m6anet dataprep --eventalign ON001-RNA-R00369_eventalign.txt --out_dir 01_ON001-RNA-R00369-dataprep --n_processes 10 --min_segment_count 10

	m6anet inference --input_dir 01_ON001-RNA-R00369-dataprep --out_dir 02_ON001-RNA-R00369-m6a --pretrained_model arabidopsis_RNA002 --n_processes 10
conda activate jxyanno
	featureCounts -T 10 -a path/.gff -o ON001-RNA-R00368.read.count -t gene -g geneID ON001-RNA-R00368_sort.bam
