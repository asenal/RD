#!/usr/bin/perl -w
#use strict;
use File::Basename;
use FindBin qw($Bin $Script);
my $help=<<qq;
Usage:
perl $0 <geno_file> <snp_file> <out_dir> <# of control> <lineal_or_collateral> <#_of_generation> <emission_P_penalty> <min_continuous_length> <boundary_to_discard>

Discription of arguments
<geno_file> 
should have format:
column 1: chr
column 2: pos
column 4: genotype concatenation
column 7-: detailed genotype infomation

<snp_file> 
File containing snp or other information, This script will output \$out_dir/\$basename.snp.processed.detail and \$out_dir/\$basename.snp.processed	 \$out_dir/\$basename.for_customer, by appending several columns to snp file

<out_dir>
 output directory

<# of control>
# of control in <geno_file>

<lineal_or_collateral>
 L for lineal blood kinships and C for collateral blood kinships, it should be a string with same # of "C or L" as combination # of every two cases. For example, four 4 cases, L for case1 and 2 , L for case 1,3 and C for case 1,4, C for case 2 and 3, C for case 2 and 4, C for case 3 and 4, \$lineal sh    ould be LLCCCC

<#_of_generation> 
For lineal blood kinships, it is number of generation between two cases. For collateral blood kinships, it is the sum of generation from two cases to their common ancestor. It should be a string with same # of digit as combination # of every two cases

<emission_P_penalty>
Penalty for emission probability from N state, which could be used to reduce amount of N state

<min_continuous_length>
The minimum # of continuous sites with the unconsistent state that would be discarded

<boundary_to_discard>
The # of sites on boundary you don't want to discard whatever state it is within

Example
/ifs1/BC_MD/suzheng/task/Linkage_Analysis/Any_Two/Backup/evaluation/run_Test_with_Junpu_data.sh

qq

unless(@ARGV==9 and -f $ARGV[0] and -f $ARGV[1] and $ARGV[3]>=0 and $ARGV[4]=~/[CL]/  and $ARGV[5]>=0 and $ARGV[6]>=0 and $ARGV[7]>=0 and $ARGV[8]>=0){
	print "Bad arguments!!\n$help";
	exit;
}
#File containing genotype information of all cases(with no control)
#Should has format like: chr1    59374   GGAA    G26G12A0        G32G12A0        A1G0A0  A1G0A0
#Third column is concatenation of genotypes
my $geno_file=shift;
#File containing snp or other information, This script will output $out_dir/$basename.snp.processed.detail and $out_dir/$basename.snp.processed.for_customer, by append several columns to snp file
my $snp_file=shift;
#output directory
my $out_dir=shift;
#  # of control in <geno_file>
my $num_of_ctrl=shift;
#L for lineal blood kinships and C for collateral blood kinships, it should be a string with same # of "C or L" as combination # of every two cases
#For example, four 4 cases, L for case1 and 2 , L for case 1,3 and C for case 1,4, C for case 2 and 3, C for case 2 and 4, C for case 3 and 4, $lineal should be LLCCCC
my $lineal=shift;
my @lineal=split //, $lineal;
#For lineal blood kinships, it is number of generation between two cases.
#For collateral blood kinships, it is the sum of generation from two cases to their common ancestor
#It should be a string with same # of digit as combination # of every two cases
my $generation=shift;
my @generation=split //,$generation;
#Penalty for emission probability from N state, which could be used to reduce amount of N state
my $penalty=shift;


#The minimum # of continuous sites with the unconsistent state that would be discard
my $continuous=shift;
#The # of sites on boundary you don't want to discard whatever state it is within
my $boundary=shift;
#State(s) which is not consistent with the disease pattern(i.e. state(s) you want to discard) e.g. PI
my $rm_state="N";
my $basename =basename $geno_file;
system "mkdir -p $out_dir" unless (-d $out_dir);
#convert MeiJunpu's input file into file with format like: chr1	2342	A TG	T89T23C0	G52G32C1
my $start_field=7+$num_of_ctrl;
#=================================================================================================
system qq{cut -f1,2,4,$start_field- $geno_file|sed 's/,\\S\\+//g' >$out_dir/$basename.genotypes_for_hmm};
$geno_file="$out_dir/$basename.genotypes_for_hmm";
#=================================================================================================

#Get number of cases
my $nu_case=`tail -1 $geno_file|awk '{print NF}'`;
#Field number minus 3(first 3 column) is case number
$nu_case=$nu_case-3;
#Number of combination
my $num_combi;
#hash to save file handles
my %file_handle;
#Get all combinations of every two cases
for my $fir(1..$nu_case){
#It is not possible that the first case is the last one
	$fir == $nu_case and last;
#Rank of second case should be more than first case 
	for my $sec( ($fir+1)..$nu_case ){
		$num_combi+=1;
		open $file_handle{"$fir$sec"}, ">$out_dir/$basename.$fir.$sec.geno" or die "$out_dir/$basename.$fir.$sec.geno!!\n";
	}
}
open I, $geno_file or die "Failed in opening $geno_file!!\n\n";
while (<I>){
	chomp;
	my @t=split;
#For every combinations of every two cases
	for my $fir(1..$nu_case){
		$fir == $nu_case and last;
		for my $sec( ($fir+1)..$nu_case ){
#Output should has format like: chr1    59374   GG    G26G12A0        G32G12A0,  which is required in $Bin/hmm_for_Any_Two_v3.pl
			print {$file_handle{"$fir$sec"}} "$t[0]\t$t[1]\t",substr($t[2+$fir],0,1),substr($t[2+$sec],0,1),"\t",$t[2+$fir],"\t",$t[2+$sec],"\n";
		}
	}
}
close I;

#when perl $Bin/Remove_Inconsistent_States.pl, two columns like "I	Inconsistent" will be append to the end of file each round, so input $snp_file should be cp to a name which is available in the loop 
system "cp $snp_file $out_dir/$basename.snp.input_for_processing";
for my $fir(1..$nu_case){
	$fir == $nu_case and last;
	for my $sec( ($fir+1)..$nu_case ){
		close $file_handle{"$fir$sec"};
		$lineal=shift @lineal;
		$generation=shift @generation;
		#print "$lineal $generation,dsd";
#Get state information, which will be save in $out_dir/$basename.$fir.$sec.geno.state
		system "perl $Bin/hmm_for_Any_Two_v4.pl $Bin/Emission_P_for_Any_Two.txt $out_dir/$basename.$fir.$sec.geno $out_dir/$basename.$fir.$sec.geno.state $lineal $generation $penalty";
#Remove inconsistent state, which will consider bondary and length of state block 
		system "perl $Bin/Remove_Inconsistent_States_v2.pl $out_dir/$basename.$fir.$sec.geno.state $out_dir/$basename.snp.input_for_processing $out_dir/$basename.snp.processed $rm_state $continuous $boundary";
		system "cp $out_dir/$basename.snp.processed $out_dir/$basename.snp.input_for_processing";
		print `date`;
		print "$basename.$fir.$sec Done!!\n\n";
	}
}
#If there is any Inconsistent in states of all cases combination, Inconsistent will be appended to the last column of file
system qq{awk '{if(\$0~"Inconsistent"){print \$0"\\tInconsistent"}else{print \$0"\\tConsistent"}}' $out_dir/$basename.snp.processed >$out_dir/$basename.snp.processed.detail};

open I,"$out_dir/$basename.snp.processed.detail";
open O, ">$out_dir/$basename.snp.processed.for_customer";
while (<I>){
	chomp;
	my @t=split /\s+/;
#Get field number
	my $nf=@t;
#Discard state information, only remain consistent or inconsistent
	map{$t[$nf-1-2*$_]="";}(1..$num_combi);
	my $out=join "\t",@t;
	$out=~s/\t\t/\t/g;
	print O "$out\n";
	
}
close I;
close O;

#Get data for R graphics. It will generate processed state for every window
system "perl $Bin/get_windows_state_for_all_individual_and_combined_v2.pl $out_dir/$basename.snp.processed.for_customer $out_dir/$basename.snp.processed.data_for_R $num_combi";
my $R_cmd=<<qq;
#!/usr/local/bin/Rscript

file <- commandArgs(TRUE)

chrplot <- function (file) {
    data <- read.table(file)
    n <- length(data)
    for (i in 8:n) {
        data[[i]] <- as.character(data[[i]])
	data[[i]][data[[i]]=="Consistent"]           <- "red"
	data[[i]][data[[i]]=="Inconsistent"]         <- "blue"
	data[[i]][data[[i]]=="Predicted_Consistent"] <- "green"
	data[[i]][data[[i]]=="Blank"]                <- "white"
    }

#    for (chr in levels(data[[1]])) {
for (nu in 1:23) {
	nu <- as.character(nu)
	nu[nu=="23"] <- "X"
	chr <- paste("chr", nu, sep="")
        color <- data[[n]][data[[1]]==chr]
	y <- seq(n-7, n-7, along=color)
	barplot(y, col=color, border="white", main=paste("State Information ", chr), cex.main=6)
	if (n != 8) {
	    for (i in (n-1):8) {
		color <- data[[i]][data[[1]]==chr]
		y <- seq(i-7, i-7, along=color)
		barplot(y, col=color, border="white", add=T)
	    }
	}
    }
}

pdf("$out_dir/$basename.all_individuals_and_combined.pdf", width=100)
chrplot(file)
dev.off()
qq

open O, ">$out_dir/$basename.all_individuals_and_combined.R";
print O $R_cmd;
close O;
system "/opt/blc/genome/bin/Rscript $out_dir/$basename.all_individuals_and_combined.R $out_dir/$basename.snp.processed.data_for_R";
