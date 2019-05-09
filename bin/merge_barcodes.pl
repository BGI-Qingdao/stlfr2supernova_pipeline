#!/usr/bin/perl
use strict;
#
# Usage     : $0 stLFR_barcode_freq 10X_white_list output_file  smallest_freq_num
# Example   : $0 barcode_freq.txt  whitelist.txt merge.txt 1
#

print "barcode_freq in $ARGV[0]\n";
print "whitelist  in $ARGV[1]\n" ;
print "output merge in $ARGV[2]\n" ;
print "smallest barcode freq is $ARGV[3]\n" ;
print "the stLFR barcode : 10x barcode map ratio is $ARGV[4]:1" ;
my $barcode_num = 0;
my @wb ;
open INb, "$ARGV[1]";
while(<INb>)
{
    chomp;
    $wb[$barcode_num]=$_ ;
    $barcode_num ++ ;
}
close(INb);

print "Total $barcode_num in whilte list of 10X is loaded !!!\n";
$| = 1;
my %bs;
my $small=$ARGV[3];
my $ratio=$ARGV[4];
my $line=0;
my $total=0;
open IN,"<$ARGV[0]";
while(<IN>)
{
    chomp ;
    my @data=split(/\t/,$_);
    $line ++ ;
    if( $line >= 1000000 && $line % 1000000 == 0 )
    {
        print "Process $line barcode freq line\n ";
        $| = 1;
    }
    $total+=$data[1];
    if ( $data[0] eq "barcode_str" 
        || $data[0] eq "Barcode_seq"
        || $data[0] eq "0" 
        || $data[0] eq "0_0"
        || $data[0] eq "0_0_0" 
        || $data[1] < $small )
    {
        next ;
    }
    $bs{$data[0]}=$data[1];
}
close(IN);

open OUT,">$ARGV[2]";
my $used=0;
my $barcode_num1=0;
foreach my $key ( keys %bs ){
    my $index=int($barcode_num1/int($ratio));
    if( $index >= $barcode_num)
    {
        last ;
    }
    print OUT "$key\t$wb[$index]\t$bs{$key}\n";
    $barcode_num1 ++ ;
    $used+=$bs{$key};
}
close(OUT);
print "Total $total pairs and used $used pairs  \n";
