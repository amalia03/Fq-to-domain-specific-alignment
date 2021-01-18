#!/bin/bash

db="/path/to/other/reference/database"
blast="/usr/local/bin/blastn"
##Input from the pipeline
query=$1

##The input filename is converted for the output filename.
blastout="$(echo $query| sed 's/.fa/\_other.bl/')"

##This command line is a typical BLAST command with some very standard parameters that can be altered.
$blast -db $db -task blastn -query $query -out $blastout -evalue 1E-10 \
    -outfmt '6 qseqid sseqid stitle staxid qlen slen qstart qend sstart send evalue score length pident nident gapopen gaps qcovs' \
    -num_threads 25 -max_target_seqs 30 -perc_identity 80

printf "Finished BLAST session against the nr/nt eukaryote domain dataset for file $blastout :\n" >> progress.txt
date >> progress.txt
