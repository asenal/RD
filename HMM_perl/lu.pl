use Data::Dumper;
#### SUB routin defination ####
sub LU{

	my $A=shift;
	my $b=shift;
	my $x=shift;
	my ($i,$n,$k,$L,$U,$sum);
	$n=$#$A+1;
	for($i=0;$i<$n;$i++){
		$U->[0][$i]=$A->[0][$i];
		#the first row of U.
		$L->[$i][$i]=1;
		if($i!=0){$L->[$i][0]=$A->[$i][0]/$U->[0][0];}
		#the first column of L .
	}
	for($k=1;$k<$n;$k++){
		for($j=$k;$j<$n;$j++){
			$sum=0;	
			for($p=0;$p<$k;$p++){$sum+=$L->[$k][$p]*$U->[$p][$j];}
			$U->[$k][$j]=$A->[$k][$j]-$sum;
		} # the K_th row of U.
		for($i=$k + 1;$i<$n;$i++){
			$sum=0;
			for($p=0;$p<$k;$p++){$sum+=$L->[$i][$p]*$U->[$p][$k];}
			$L->[$i][$k]=($A->[$i][$k]-$sum)/$U->[$k][$k];
		} # the K_th column of L.
	}
=head
# Print L,U #	
	print "L is :\n";
	for($i=0;$i<$n;$i++){
		for($j=0;$j<=$i;$j++){ print "$L->[$i][$j] \t";}
		print "\n";
	}
	print "\nU is :\n";
	for($i=0;$i<$n;$i++){
		for($j=$i;$j<$n;$j++){ print "$U->[$i][$j] \t";}
		print "\n";
	}
=cut
### solve L*y=b and U*x=y   ###
	my $y;
	$y->[0]=$b->[0];
	for($i=0;$i<$n;$i++){
		$sum=0;
		for($j=0;$j<$i;$j++){$sum+=$L->[$i][$j]*$y->[$j];}
		$y->[$i]=$b->[$i]-$sum;
	}
	$x->[$n-1]=$y->[$n-1]/$U->[$n-1][$n-1];
	for($i=$n-2;$i>=0;$i--){
		$sum=0;
		for($j=$i+1;$j<$n;$j++){$sum+=$U->[$i][$j]*$x->[$j];}
		$x->[$i]=($y->[$i]-$sum)/$U->[$i][$i];
	}
}
### subroutin defination : the bias of lu decomposition : sqrt[sigma (x-x_lu)^2] ###
sub Bias{
		my $A=shift;
		my $b=shift;
		my $x=shift;
		my ($i,$j,$bias,$n,$tmp);
		$n=$#$A + 1;
		for($i=0;$i<$n;$i++){
			$tmp=0;
			for($j=0;$j<$n;$j++){$tmp+=$A->[$i][$j]*$x->[$j];}
			$bias+=($b->[$i] - $tmp)**2;
			print "$bias\n";
		}
		$bias=sqrt $bias;
}

