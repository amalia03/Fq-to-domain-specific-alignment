#!/usr/bin/env perl

#use strict;
use warnings;
use List::Util qw(shuffle);
use Fcntl qw(SEEK_CUR);

($inFn, $subsample) = @ARGV;
#$random_seqs = "rando_$inFn";
#my $inFn = "all_raw_seqs_together.fa";
my $n = $subsample;

my ($inFh, $seqs, $seqIdx, $start, $end, $seq);

#
# discover byte bounds of FASTA sequences
#

$seqIdx = 0;
open $inFh, "<", $inFn or die "could not open FASTA input\n$?";
while (<$inFh>) {
    if ($_ =~ /^>/) {
#tell retirns the current position for filehandle
        $start = (tell $inFh) - length($_);
        if ($start == 0) {
            $seqs->[$seqIdx]->{startByte} = $start;
        }
        else {
            $end = $start - 1;
            $seqs->[$seqIdx]->{endByte} = $end;
            $seqIdx++;
            $seqs->[$seqIdx]->{startByte} = $start;
        }
    }
}
$end = tell $inFh;
$seqs->[$seqIdx]->{endByte} = $end;
close $inFh;

#

#
# permute indices
# sample first N elements from permuted indices
# sort indices
#

my @idxs = map { $_ } (0 .. scalar(@{$seqs}) - 1);
my @shuffledIdxs = shuffle @idxs;
undef @idxs;
my @sampleIdxs = @shuffledIdxs[0..($n - 1)];
my @sortedSampleIdxs = sort { $a <=> $b } @sampleIdxs;

#
# draw the sample of sequence byte boundaries
#

my @sampleSeqs = map { $seqs->[$_] } @sortedSampleIdxs;

#
# read out sampled sequences from input FASTA file
# as byte offsets are ordered, we can use SEEK_CUR to minimize I/O from seeking through file
#

my $pStart = 0;
my $pLength = 0;
open $inFh, "<", $inFn or die "could not open FASTA input\n$?";
#open($rando, ">", $random_seqs);
foreach (@sampleSeqs) {
    seek $inFh, $_->{startByte} - $pStart - $pLength, SEEK_CUR;
    $pStart = $_->{startByte};
    $pLength = $_->{endByte} - $_->{startByte};
    read $inFh, $seq, $pLength;
#    print $rando "$seq\n";
    print "$seq\n";
}
close $inFh;
#close $rando;

