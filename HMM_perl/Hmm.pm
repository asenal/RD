package Hmm; 
use Data::Dumper;
use SVG;
use strict;
do 'lu.pl';
sub new{    
	my $class = shift; my $hmmfile=shift;
	# $hmmfile=\*HMMFILE,point to a filehandle,this is a typeglob
	my $line;my $flag;
	my $ref;my @states;my @symbols;my @starts;my @transProbs;my @emissProbs;
	while($line=<$hmmfile>){
	if($line =~ />states/){$line=<$hmmfile>;chomp $line;@states=split /\s+/,$line;}
	if($line =~ />symbols/){$line=<$hmmfile>;chomp $line;@symbols=split /\s+/,$line;}
	if($line =~ />starts/){$line=<$hmmfile>;chomp $line;@starts=split /\s+/,$line;}
	if($line =~ />transProbs/){
		$flag=1;
		while($flag){
			$line=<$hmmfile>;
			if($line !~ />emissProbs/){	chomp $line; my @tmp=split /\s+/,$line; push @transProbs,[@tmp];}else{$flag--;}
			}
		}
	if($line =~ />emissProbs/){
		$flag=1;
		while($flag){
			$line=<$hmmfile>;
			if($line !~ />#/){ chomp $line; my @tmp=split /\s+/,$line; push @emissProbs,[@tmp];} else{$flag--;}
			}
		}
	}
	$ref={"states"=>\@states,"symbols"=>\@symbols,"starts"=>\@starts,"transProbs"=>\@transProbs,"emissProbs"=>\@emissProbs};
	bless ($ref,$class);
	return $ref;             
}

###################################
sub simu{	           
	my $ref=shift; my $observe=shift;
	my $length;
	$length=(defined($length=shift)) ? $length : 100;
	my @states=@{$ref->{"states"}};my @symbols=@{$ref->{"symbols"}};
	my @transProbs=@{$ref->{"transProbs"}};my @emissProbs=@{$ref->{"emissProbs"}};
	my ($count,$i,$j,$iter,$sum,$rand);
	$rand=rand;
	$i=int ($rand * $#transProbs);
	# initialize the first state.
	srand;	
	# seed of random series.
	for($iter=1;$iter<=$length;$iter++){
		$rand=rand;       
	  	$j=0;$sum=0;
		$sum+=$transProbs[$i][$j]; 
		while($sum<$rand){
			$j++;	#like a clock!! 							
			$sum+=$transProbs[$i][$j];
			} # state is determined as $j.          
		$count=0;$sum=0;	
		$sum+=$emissProbs[$j][$count];
		while($sum<$rand){
			$count++;				
			$sum+=$emissProbs[$j][$count];
			} # observe is determined as $count.	
		push @{$observe},$symbols[$count];	
		$i=$j;
	}
}


####################################
sub forward{
	my $ref=shift;my $observe=shift;my $forward=shift;
	my ($now,$i,$j,$iter,$logsum,$state_num,$symbol_num,$sum,$ob_length,$index);
	my @states=@{$ref->{"states"}};my @symbols=@{$ref->{"symbols"}};
	my @transProbs=@{$ref->{"transProbs"}};my @emissProbs=@{$ref->{"emissProbs"}};
	$state_num=$#states; $symbol_num=$#symbols;
	my @observe_numeral=@{$observe};
	my $text;
	for($i=0;$i<=$symbol_num;$i++){
		$text=$ref->{"symbols"}[$i];
		for($j=0;$j<=$#observe_numeral;$j++){if($observe_numeral[$j] eq $text){$observe_numeral[$j]=$i;}}
	}
	# convert text labeled @observe to a numeral labeled @observe_numeral
	for($i=0;$i<=$state_num;$i++){$$forward[0][$i]=log(($ref->{"starts"}[$i])*($emissProbs[$i][$observe_numeral[0]]));}
	for($iter=1;$iter<=$#observe_numeral;$iter++){
		$index=$observe_numeral[$iter];
		for($i=0;$i<=$state_num;$i++){
			for($j=0;$j<=$state_num;$j++){# j is previous state index.
				$now=$$forward[$iter-1][$j] + log($transProbs[$j][$i]);
				if(defined($logsum)){ $logsum=$now + log(1 + exp($logsum - $now));}else{$logsum=$now;}
			}
			$now=$logsum+log $emissProbs[$i][$index];
			# $now is temporal para,has nothing to do with the former. 
			$$forward[$iter][$i]=$now ; 
			$logsum=undef;
		}
	}		
}

###################################
sub backward{
	my $ref=shift; my $observe=shift; my $backward=shift;
	my ($now,$logsum,$i,$j,$iter,$state_num,$symbol_num,$sum,$ob_length,$index);
	my @states=@{$ref->{"states"}};my @symbols=@{$ref->{"symbols"}};
	my @transProbs=@{$ref->{"transProbs"}};my @emissProbs=@{$ref->{"emissProbs"}};
	$state_num=$#states; $symbol_num=$#symbols;
	my @observe_numeral=@{$observe};
	my $text;
	for($i=0;$i<=$symbol_num;$i++){
		$text=$ref->{"symbols"}[$i];
		for($j=0;$j<=$#observe_numeral;$j++){	
			if($observe_numeral[$j] eq $text){$observe_numeral[$j]=$i;}
		}
	}
	$ob_length=$#observe_numeral;
	for($i=0;$i<=$state_num;$i++){$$backward[$ob_length][$i]=0;}
	for($iter=$ob_length-1;$iter> -1;$iter--){
		$index=$observe_numeral[$iter];
		for($i=0;$i<=$state_num;$i++){
			for($j=0;$j<=$state_num;$j++){
				$now=$$backward[$iter+1][$j] + log($transProbs[$i][$j]); # correct j,i to i,j!
				if(defined($logsum)){ $logsum=$now + log(1 + exp($logsum - $now));}else{$logsum=$now;}
			}
			$now=$logsum + log $emissProbs[$i][$index];
			$$backward[$iter][$i]=$now;
			$logsum=undef;
		}
	}
}

################################
sub viterbi{
	my $ref=shift; my $observe=shift; my $viterbipath=shift;
	my ($ob,$now,$previous,$max,$i,$j,$iter,$state_num,$symbol_num,$ob_length,$index);
	my @states=@{$ref->{"states"}};my @symbols=@{$ref->{"symbols"}};
	my @transProbs=@{$ref->{"transProbs"}};my @emissProbs=@{$ref->{"emissProbs"}};
	$state_num=$#states; $symbol_num=$#symbols;
    my $text;
	my @observe_numeral=@{$observe};
	for($i=0;$i<=$symbol_num;$i++){
		$text=$ref->{"symbols"}[$i];
		for($j=0;$j<=$#observe_numeral;$j++){if($observe_numeral[$j] eq $text){$observe_numeral[$j]=$i;}}
	}
	$ob_length=$#observe_numeral;
	#### generation ####
	my @tmp;my @direction;
	$index=$observe_numeral[0];
	for($i=0;$i<=$state_num;$i++){
		$tmp[0][$i]=log ($ref->{"starts"}[$i] * $emissProbs[$i][$index]);	
	}
	for($iter=0;$iter<=$#observe_numeral;$iter++){
		$ob=$observe_numeral[$iter];
		# $index is the observation at $iter.
		for($i=0;$i<=$state_num;$i++){
			($max,$index)=($tmp[$iter-1][0] + log($transProbs[0][$i]),0);
			for($j=1;$j<=$state_num;$j++){
			($max,$index) = ($max < $tmp[$iter-1][$j] + log($transProbs[$j][$i])) ? ($tmp[$iter-1][$j] + log($transProbs[$j][$i]),$j) : ($max,$index);
			}
			$tmp[$iter][$i]=$max + log($emissProbs[$i][$ob]);
			$direction[$iter][$i]=$index;
			# leave $direction[0] undefined,but it'll be very convinient when tracing back.
		}
	}
	##### tracing back ####
	($max,$index)=($tmp[$ob_length][0],0);
	for($i=1;$i<=$state_num;$i++){
		($max,$index)= ($max > $tmp[$ob_length][$i]) ? ($max,$index) : ($tmp[$ob_length][$i],$i);
	}
	unshift @{$viterbipath},$states[$index];   # unshift the first.
	# the output @viterbipath is 'text-labeled' ,this is a convertion line : $states[$index]->'text'.
	for($iter=$#observe_numeral-1;$iter>=0;$iter--){
		# the last state_index is set,so interation begins from $#observe_numeral-1,since the 1st row of @direction is undefined ,iteration ends at 1.
		$index=$direction[$iter][$index];
		unshift @{$viterbipath},$states[$index];
	}
}

####################################
sub BaumWelch{
	my $ref=shift;my $observe=shift; 
	my ($seed_max,$iter_max,$threshhold);
	$iter_max=(defined ($iter_max=shift)) ? $iter_max : 8;
	$threshhold=(defined ($threshhold=shift)) ? $threshhold : 1e-8;	
	$seed_max=(defined ($seed_max=shift)) ? $seed_max : 4;
	my ($seed,$T_bias,$E_bias,$total_prob,$count,$delta,$now,$k,$i,$j,$iter,$state_num,$symbol_num,$ob_length,$index);
	my @states=@{$ref->{"states"}};my @symbols=@{$ref->{"symbols"}};
	my @transProbs=@{$ref->{"transProbs"}};my @emissProbs=@{$ref->{"emissProbs"}};
	$state_num=$#states; $symbol_num=$#symbols;
	my @observe_numeral=@{$observe}; $ob_length=$#observe_numeral;
	my $text;
	for($i=0;$i<=$symbol_num;$i++){
		$text=$ref->{"symbols"}[$i];
		for($j=0;$j<=$ob_length;$j++){if($observe_numeral[$j] eq $text){$observe_numeral[$j]=$i;}}
	}
	#### iteraton####
	my @lala;my @gamma;my @forward;my @backward;my @Delta;my @total_probs;my @seedtmp;
	for($seed=1;$seed<=$seed_max;$seed++){
		for($i=0;$i<=$state_num;$i++){
			$now=0;
			for($j=0;$j<=$state_num;$j++){$seedtmp[$i][$j]=rand;$now+=$seedtmp[$i][$j];}
			for($j=0;$j<=$state_num;$j++){$transProbs[$i][$j]=$seedtmp[$i][$j]/$now;}
		}
		for($i=0;$i<=$state_num;$i++){
			$now=0;
			for($j=0;$j<=$symbol_num;$j++){$seedtmp[$i][$j]=rand;$now+=$seedtmp[$i][$j];}
			for($j=0;$j<=$symbol_num;$j++){$emissProbs[$i][$j]=$seedtmp[$i][$j]/$now;}
		}	 
	#####	make the initial solution for $seed.####	
		print "this is the origin\n";
		print Dumper @transProbs;print Dumper @emissProbs;
		print Dumper $observe;
		for($iter=1;$iter<=$iter_max;$iter++){
			$ref->forward(\@{$observe},\@forward);
			$ref->backward(\@{$observe},\@backward);
			for($i=0;$i<=$state_num;$i++){$total_prob += exp $forward[$ob_length][$i];};push @total_probs,$total_prob;
			# this is not neccesary in standard Baum-Welch ,but hope it'll help in convergence analysis.
			#### E-step
			$delta=0;
			@gamma=undef;
			@lala=undef;
			for($i=0;$i<=$state_num;$i++){
				for($j=0;$j<=$state_num;$j++){
					for($count = 0;$count<$ob_length;$count++){
						$index = $observe_numeral[$count];
						$now   = $forward[$count][$i]+(log $transProbs[$i][$j])+(log $emissProbs[$j][$index])+$backward[$count + 1][$j];
						if(defined($lala[$i][$j])){$lala[$i][$j]=$now+log(1+exp($lala[$i][$j]-$now));}else{$lala[$i][$j]=$now;}
					print "i,j: $i $j,index: $index now: $now lala[i,j]: $lala[$i][$j]\n";
					}
				}
				for($count = 0;$count<$ob_length;$count++){
					$index = $observe_numeral[$count];
					$now   = $forward[$count][$i]+$backward[$count][$i];
					if(defined($gamma[$i]->{$index})){$gamma[$i]->{$index}=$now+log(1+exp($gamma[$i]->{$index}-$now));}else{$gamma[$i]->{$index}=$now;}
					print "i: $i index: $index now: $now,gamma[i]-> $index: $gamma[$i]->{$index}\n";
				}
				for($count = 0;$count<=$symbol_num;$count++){
					if(defined($gamma[$i]->{$count})){
						if(defined($gamma[$i]->{"total"})){
							$gamma[$i]->{"total"}=$gamma[$i]->{$count}+log(1+exp($gamma[$i]->{"total"}-$gamma[$i]->{$count}));
						}else{$gamma[$i]->{"total"}=$gamma[$i]->{$count};}
					}
				}
			}
			print "lala\n";
			print Dumper @lala;
			print Dumper @gamma;
			#### M-step
			for($i=0;$i<=$state_num;$i++){
				$T_bias=0;$E_bias=0;
				for($j=0;$j<=$state_num;$j++){
					$now=exp ($lala[$i][$j] - $gamma[$i]->{"total"});
					$T_bias+=($now-$transProbs[$i][$j])**2;
					$transProbs[$i][$j]=$now;
				}
				for($j=0;$j<=$symbol_num;$j++){
					$now=exp ($gamma[$i]->{$j} - $gamma[$i]->{"total"});
					$E_bias+=($now-$emissProbs[$i][$j])**2;
					$emissProbs[$i][$j]=$now;
				}
			}
			$delta=$T_bias+$E_bias; push @Delta,$delta;
			if($delta<$threshhold){last;}
			print Dumper @transProbs;print Dumper @emissProbs;
		}
		open LOG,">>","train.log";
	   	print LOG  "the $seed seed:\n"; print LOG Dumper @Delta; print LOG "\ntransProbs\n";print LOG Dumper @transProbs;print LOG "emissProbs\n";print LOG Dumper @emissProbs;
		close LOG ;
	}
}

1;
