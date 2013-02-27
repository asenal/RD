#!/usr/bin/perl -w
# Asenal 2011,08,26
use strict;
use Data::Dumper;
use Tree;
use Getopt::Long;
my ($tree,$
open MAF,"<",$ARGV[0];
my $tree=Tree->new(\*MAF);
close MAF;

#print Dumper $hmm;
