#!/usr/bin/perl -w
# Asenal 2011,04,29
use strict;
use Data::Dumper;
use Hmm;
use MatrixReal;
do "lu.pl";#contains the defination of LU decomposition.

open HMMFILE,"<",$ARGV[0];
my $hmm=Hmm->new(\*HMMFILE);
close HMMFILE;
#print Dumper $hmm;
my @observe;my @backward;my @forward; my @viterbipath;
$hmm->simu(\@observe,20);
$hmm->forward(\@observe,\@forward);
#$hmm->backward(\@observe,\@backward);
#$hmm->viterbi(\@observe,\@viterbipath);
#$hmm->BaumWelch(\@observe,10,1e-8,1);
print Dumper @observe;    #checked
print Dumper @forward;    #checked
#print Dumper @backward;   #checked	
#print Dumper @viterbipath;#checked



#####################  ignore the rest #######################
=head
## Math::MatrixReal part ##
my $A=Math::MatrixReal->new_random(3,3);
print  "$A\n";
my $B=$A**-1;
print $B;
my $C=Math::MatrixReal->new_from_rows([[1,2,3],[2,3,4],[3,4,5]]);
print "$C\n";

my ($a,$b,$c)=(15,-4,15);
my $D=Math::MatrixReal->new_from_string(<<"MAT");
[ $a ]
[ $b ]
[ $c ]
MAT
print "the b vector is :\n";
print "$D\n";
my $E=Math::MatrixReal->new_from_string(<<"MAT");
[ 4 -1 2 ]
[ 1 3 -1 ]
[ 2 1 4 ]
MAT
print "the A matrix is :\n";
print "$E\n";

my  ($dim,$x,$test);
my ($E_,$D_)=$E->normalize($D);
my $LR=$E_->decompose_LR();
if(($dim,$x,$E_)=$LR->solve_LR($D_)){
	$test=$E_*$x;
	print "x=\n";print "$x";
}
my $LR=$E->decompose_LR();
if(($dim,$x,$E)=$LR->solve_LR($D)){
	$test=$E*$x;
	print "x=\n";print "$x";
}
=cut
