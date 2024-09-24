# Fq-to-domain-specific-alignment
Alignment of subsampled fq reads to three domain depositories

This pipeline has two parts:

The **first** part takes the NCBI taxonomy database and based on the taxonomy information they provide, it creates three domain groups: for eykaryotes, prokaryotes and Uknown (which includes all the rest, including the viruses and archaea).
These groups serve as three separate reference databases which would be accessed in the alignment step. 

The **second** part aligns a subsample of a list of Fastq files to those three domains. To be a bit more detailed the pipeline: 
- Reads in each fq file. 
- Converts them to a temporary fa file.
- Picks a random subsample (the number of random samples can be adjusted here). 
- Aligns that subsample to each BLAST file. 
- The data are depicted using R.

### Part 1: setting up the domain directories. 

### Part 2: the access, alignment and analysis of the samples:

For this section one or more sets of fastq files is required.

To initiate the pipeline, you need to adjust the locations in the files and initiate the main command by writing:

`./import_fq.sh`

Following are the scripts the pipeline uses in more detail:

**import_fq.sh** -> the initiation command, it access the folder where the samples are and creates a command loop for each sample. The default choice of fw files is ".fq" but the code can be accessed to allow for more specialised file searches. 

**fq_fa_blast.sh** -> this is the main pipeline command. It converts the fq file to an fa file, picks up n random sequences and then BLASTs them through the three different domain files. This script utilizes all the scrips described below. 

**fastq_to_fasta.sh** -> Converts the fastq file to a fasta file.

**random_seq.pl** -> Selects a random subsample of sequences from the fasta file and creates an output file with the subsamples. The FASTA file is removed.

**euk_subset_blast.sh, prok_subset_blast.sh, other_subset_blast.sh** -> these three scripts perform a BLASTn local alignment to the random sample against the eukaryote,
prokaryote and "other" reference database respectively. 

The last step generates three separate BLASt alignments for each domain.
