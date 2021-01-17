# Fq-to-domain-specific-alignment
Alignment of subsampled fq reads to three domain depositories

This pipelines have two parts:

The **first** part takes the NCBI taxonomy database and based on the taxonomy information they provide, it creates three different domain groups: for eykaryotes, prokaryotes and Uknown (which includes all the rest, including the viruses and archaea).
These groups serve as three separate reference databases which would be accessed in the alignment step. 

The **second** part aligns a subsample of a list of Fastq files to those three domains. To be a bit more detailed the pipeline: 
- Reads in each fq file. 
- Converts them to a temporary fa file.
- Picks a random subsample. 
- Aligns that subsample to each BLAST file. 
- The data are depicted using R.
