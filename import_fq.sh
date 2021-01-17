#!/bin/bash

###This script reads through a list of samples and process them through the pipeline. 
If there are only a handful of samples or if the user wants to assess them individually, this command can be skipped for the next one, **fq_fa_blast.sh**

##Set directories for the sample location and the working directory aka the directory where all the script are located. 
fq_loc="/path/to/sample/directory/"
bl_loc="/path/to/working/directory/"

printf "Started file conversion and domain BLAST at:\n" > progress.txt
date >> progress.txt


cd "$fq_loc"
##Here the default is to get all the sequences from the first pair but it can be changed
samples="*R1*val_1.fq"

##Perform a loop that initiates the FASTA conversion and alignment command with each sample.

for i in $samples;

do

    printf "$i\n\n"
###Here it copies the file to the working directory location. Maybe a soft link would be a better solution for the next version. 
    cp $i "$bl_loc"
    cd "$bl_loc"
    ./fq_fa_blast.sh $i
###After the command has been executed, the FASTQ file is removed. 
    rm $i

    cd "$fq_loc"

done

