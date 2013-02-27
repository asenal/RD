#!/usr/bin/perl -w
my $usage=<<USAGE;		#print help to STDOUT
Description: this script draw a tree from file or a array that stores a newick tree.
Dependency: SVG package is required
Date: 2011-09-09
Contact: <asenalhere\@gmail.com>

Usage:$0 <*.newick>
Example:
perl drawtree.pl *.newick
USAGE

use strict;
use Data::Dumper;
use SVG;
use Getopt::Long;

open IN,$ARGV[0];
&drawtree(\*IN);
close IN;

# subroutin defination
sub drawtree{
  if ($#ARGV<0) {
    die $usage;
  }
  my $width=800;my $height=800;
  my $x_seg=80; my $y_seg=80;
				# the seg add at x-axes and y-axes
  my $font_size=13;
  my $svg=SVG->new('width',$width,'height',$height);
  my $newickfile=shift; #$newickfile=\*NEWIto_xKFILE,refers to a filehandle,this is a typeglob
  my ($name,$count,$r_count,$l_count,$tmp,$line,$length,$xpos,$ypos,$x_uptonow,$y_uptonow,$from_x,$from_y,$to_x,$to_y,$l_pop);
  my (@lines,@stacks);
  my (%l_child,%r_child,%tree);
  $/="\n\n"; $line=<$newickfile>; $/="\n";
  $line=~s/\n//;
  @lines=split //,$line;
  while (defined ($tmp=shift @lines)) {
    if ($tmp=~/[A-Za-z\-]/) {
      if (defined $name) {
	$name=$name.$tmp;
      } else {
	$x_uptonow++;$xpos=$x_uptonow;$ypos=0;$name=$tmp;
      }
      next;
    } elsif ($tmp=~/\d|\./) {
      if (defined $length) {
	$length=$length.$tmp;
      } else {
	$length=$tmp;
      }
      next;
    } elsif ($tmp=~/,/) {
      $l_count++;
      $l_child{$l_count}={"name"=>$name,"length"=>$length,"xpos"=>$xpos,"ypos"=>$ypos,};
      $name=undef;$length=undef;$xpos=undef;$ypos=undef;
      push @stacks,$l_count;
      next;
    } elsif ($tmp=~/\)/) {
      $r_count++;
      $r_child{$r_count}={"name"=>$name,"length"=>$length,"xpos"=>$xpos,"ypos"=>$ypos};
      $l_pop=pop @stacks;   
      #r_count syncronizes tree_count
      $tree{$r_count}={
		       "l_child" => $l_child{$l_pop}, 
		       "r_child" => $r_child{$r_count},
		       "l_length" => $l_child{$l_pop}->{length},
		       "r_length" => $r_child{$r_count}->{length},
		       "score"=>undef, "word"=>undef,
		      };
      $name="nonleaf";$length=undef;
      $xpos=($l_child{$l_pop}->{xpos}+$r_child{$r_count}->{xpos})/2;
      $ypos=(($l_child{$l_pop}->{ypos})>($r_child{$r_count}->{ypos})) ? ($l_child{$l_pop}->{ypos}):($r_child{$r_count}->{ypos});
      $ypos++;
      #draw the line
      $from_x=$x_seg*$l_child{$l_pop}->{xpos}; $from_y=0.9*$height-$y_seg*$l_child{$l_pop}->{ypos};
      $to_x=$x_seg*$r_child{$r_count}->{xpos}; $to_y=0.9*$height-$y_seg*$r_child{$r_count}->{ypos};
      $y_uptonow=0.9*$height-$y_seg*$ypos;
      $svg->path('d',"M $from_x $from_y L $from_x $y_uptonow L $to_x $y_uptonow L $to_x $to_y",'stroke',"black",'fill','none'); 
      if ($l_child{$l_pop}->{name} ne "nonleaf") {
	$tmp=$l_child{$l_pop}->{name};	
	$svg->text('x',$from_x,'y',$from_y+20,'-cdata',$tmp,'font-size',$font_size);
      }
      if (defined ($tmp=$l_child{$l_pop}->{length})) {
	$svg->text('x',$from_x,'y',$from_y,'-cdata',$tmp,'font-size',$font_size,'transform',"rotate(-90 $from_x,$from_y)");
      }
      if ($r_child{$r_count}->{name} ne "nonleaf") {
	$tmp=$r_child{$r_count}->{name};	
	$svg->text('x',$to_x,'y',$to_y+20,'-cdata',$tmp,'font-size',$font_size);
      }
      if (defined ($tmp=$r_child{$r_count}->{length})) {
	$svg->text('x',$to_x,'y',$to_y,'-cdata',$tmp,'font-size',$font_size,'transform',"rotate(-90 $to_x,$to_y)");
      }
      next;
    }
  }
  open S,">","tree.svg";
  print S $svg->xmlify();
  close S;
  print Dumper %tree;
}

