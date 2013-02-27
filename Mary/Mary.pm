# this is a pm file to realize some evolution algorithms 
# some subroutines:
=head
	readmaf
	sitepattern&parsimony
	ml
	bootstrap
	drawtree

=cut
#yuqiulin 2011.08.31 asenalhere@gmail.com
package Mary; 
use Data::Dumper;
use SVG;
use strict;

#do 'lu.pl'; refers to a out-defined function.

sub readmaf{    
my $class=shift; my $maf=shift; my $ref;
my ($me,$flag,$i,$j,$count,$specinum,$seq,$tmp,$GC,$line,$subline,$index,$block)	;
my (@lines,@sublines,@tmps,@seqs,@alphabeta,@nscore,@subnscore,@content);
my (%mary,%Score);

## count the number of species ##
open MAF,"<",$ARGV[0];
$/="\n\n";
$seq=<MAF>;
@lines=split /\n/ ,$seq;
$specinum=$#lines;
# the "a score=***" line doesn't count.
close MAF;
print "the number of species is :$specinum\n" ;

## cumulate the n base score for each  aligned row ## 
open MAF,"<",$ARGV[0];
$/="\n\n";
while($block=<MAF>){
				my @lines=split /\n/ ,$block;
				$index=-1;
				shift @lines; # shift the "a score=**" line.
				@subnscore=();				
				foreach $subline (@lines){
								$index++;
								@tmps=split /\s+/,$subline;
								$seq=$tmps[6];
								$seq=~ tr/acgtACGT-/012301234/;
								@seqs=split //,$seq;
								$count=-1;
								foreach $me (@seqs){
												$count++;
												$subnscore[$count]+=($seqs[$count]*(5**$index));
								}
## cumulate the 'ACGT-' content for each subline##
								{
												$tmp=$seq =~ tr/0//;print "$tmp\n";$content[0]+=$tmp;
												$tmp=$seq =~ tr/1//;print "$tmp\n";$content[1]+=$tmp;
												$tmp=$seq =~ tr/2//;print "$tmp\n";$content[2]+=$tmp;
												$tmp=$seq =~ tr/3//;print "$tmp\n";$content[3]+=$tmp;
												$tmp=$seq =~ tr/4//;print "$tmp\n";$content[4]+=$tmp;
												my $contentsum=0;
												foreach $tmp (@content){$contentsum+=$tmp;}
											 	for($i=0;$i<4;$i++){$content[$i]=$tmp/$contentsum;}
								}
				}
				push @nscore,@subnscore;
}
close MAF;			
## backup the hash to binary file "mary.hash" ##
@{$mary{"content"}}=@content;
@{$mary{"nscore"}}=@nscore;
${$mary{"specinum"}}=$specinum;
## "mary.hash" is the default file to store the hash##
bless ($ref,$class);
return $ref;             
}

###########################
sub parsimony{




########
1;
