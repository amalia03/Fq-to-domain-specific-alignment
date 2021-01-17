#!/bin/bash
##This command is the main part of the pipeline, it calls for all the scripts that will be used downstream, to convert, randomly subset and align the sample.

##For the fqfile, the input value is either determined by the outer command, import_fq.sh, or by the name of the sample. Therefore this command can be called by writing
## fq_fa_blast.sh Sample
fqfile=$1

##Remove the ending from the FASTQ file name...
fafile="$(echo $fqfile| sed 's/_001_val_1.fq//')"
##and replace it with the subset FASTA identifier which will be used later
rand_fa="$fafile""_sbst.fa"

##Initiate command that converts the FASTQ file to FASTA and creates a temporary FASTA file
fastq_to_fasta.sh $fqfile > $fafile

printf "Converted $fqfile to $fafile.\n"
printf "Converted $fqfile to $fafile.\n" >> progress.txt

#Take a random subset of the FASTA sequences (default is 75000) and output to the FASTA subset file. 
./random_seq.pl $fafile 75000 > $rand_fa

printf "Finished random subsetting of $fafile.\n"

#Remove the FASTA file with the complete set of sequences. 
rm $fafile

printf "Removed $fafile. Initiating BLAST command using $rand_fa\n"
printf "Removed $fafile. Initiating BLAST command using $rand_fa\n" >> progress.txt

##Initiate the commands that will align the sequences to the customised NCBI database for each separate domain. 
./euk_subset_blast.sh $rand_fa
./prok_subset_blast.sh $rand_fa
./other_subset_blast.sh $rand_fa
