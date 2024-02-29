##################################
hifiasm
##################################

conda activate py3

	samtools view $sample.hifi_reads.bam | awk '{print ">"$1"\n"$10}' >$sample.fasta
	tar -xvf fast5_fail.tar
	cat path/20230725_1905_4D_PAO91701_9a3670e5/fastq_pass/*gz >$sample_ont-ul.fq.gz
	gunzip -c $sample_ont-ul.fq.gz | awk '{if(NR%4==1) {printf(">%s\n",substr($0,2));} else if(NR%4==2) print;}' > $sample_ont-ul.fa


conda activate python3
	seqkit seq -j 8 $sample_ont-ul.fq.gz > $sample_ont-ul.fa
	seqkit stats -j 8 $sample_ont-ul.fa -T >$sample_ont-ul.fa.length.txt
	seqkit seq -j 10 -m 20000 $sample_fast5_fail.fa > $sample_fast5_fail-20kb.fa
	
#
conda activate pacbio

	hifiasm -o $sample_ont20kb-all.asm -t 28 --ul $sample_ont-20kb-all.fa.gz --h1 path/fastq/H259_DKDL230002807-1A_H3KGWDSX7_L2_R1.fastq.gz --h2 path/fastq/H259_DKDL230002807-1A_H3KGWDSX7_L2_R2.fastq.gz $sample.fasta.gz $sample_2.fasta.gz

#get contig,
	awk '/^S/{print ">"$2;print $3}' $sample_ont20kb-all.asm.hic.p_ctg.gfa >01_$sample_ont.p_ctg.fa
#
	busco -f -c 16 -i 01_$sample_ont.p_ctg.fa -o 02_$sample_ont -l path/eudicots_odb10 -m genome --offline
#
#################################
flye 
##################################

conda activate pacbio

	flye --nano-corr $sample_ont-20kb-all.fa.gz --out-dir 01_nano_ctg2 --threads 20 --iterations 3 --genome-size 2.6g
#get contig,
	busco -f -c 16 -i 01_$sample_ont.p_ctg.fa -o 02_$sample_ont -l /gpfsdata/LishaLab/02_lettuce/05_pacbio/01_oilseeds_lettuce/eudicots_odb10 -m genome --offline
#
###################################
juicer-3dgenome
##################################
conda activate py3
	bwa index sample_ont.p_ctg.fa
	python ./juicer/misc/generate_site_positions.py DpnII sample_ont sample_ont.p_ctg.fa
	awk 'BEGIN{OFS="\t"}{print $1, $NF}' sample_ont_DpnII.txt > sample_ont.chrom.sizes

conda activate py2

	./juicer/scripts/juicer.sh -g G103 -z sample_ont.p_ctg.fa -p sample_ont.chrom.sizes -y sample_ont_DpnII.txt -D ./juicer -t 18
	samtools view -@ 20 -O SAM -F 1024 ./aligned/merged_dedup.*am | awk -v mnd=1 -f ./juicer/scripts/common/sam_to_pre.awk > ./aligned/merged_nodups.txt

conda activate py3
	./3d-dna-master/run-asm-pipeline.sh -r 0 sample_ont.p_ctg.fa aligned/merged_nodups.txt &> log.txt
#review
	./3d-dna-72a87ac/run-asm-pipeline-post-review.sh -r sample_ont.p_ctg.0.review.assembly sample_ont.p_ctg.fa ./aligned/merged_nodups.txt
	./AGWG-merge-master/finalize/finalize-output.sh -l sample_ont.p_ctg sample_ont.p_ctg.final.cprops sample_ont.p_ctg.final.asm sample_ont.p_ctg.final.fasta final
	ln -sf AGWG.FINAL.fasta AGWG.HiC.fasta
conda activate pacbio
	stats.sh in=sample_ont.p_ctg.fa >01_sample_ont_bbtools_out.log
	
	perl ./NGenomeSyn/bin/GetTwoGenomeSyn.pl -NumThreads 10 -InGenomeA 02_G259_ont_Chr.fa -InGenomeB ./Stem_lettuce_genome.v1.1c.fa -OutPrefix ./02_GenomeSyn_20kb-rv/sample_ont-stem -MappingBin mummer -BinDir /oceanstor/scratch/tlllisha/caoshuai/conda/py3/bin -MinAlnLen 20000
