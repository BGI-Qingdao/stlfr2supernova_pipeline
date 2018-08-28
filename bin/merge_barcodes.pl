#!/usr/bin/perl
#
# Usage     : $0 stLFR_barcode_freq 10X_white_list output_file  smallest_freq_num
# Example   : $0 barcode_freq.txt  whitelist.txt merge.txt 1
#
open INb, "$ARGV[1]";
while(<INb>)
{
    chomp;
    $wb[$barcode_num]=$_ ;
    $barcode_num ++ ;
}

print "Total $barcode_num in whilte list of 10X is loaded !!!\n";
close(INb);

$curr_barcode=1;
open IN,"<$ARGV[0]";
open OUT,">$ARGV[2]";
$line=0;
$total=0;
$small=$ARGV[3];

while(<IN>)
{
    chomp ;
    my @data=split(/\t/,$_);
    $line ++ ;
    $total+=$data[1];
    if ( $data[0] == 0  || $data[0] == "0_0_0" || $data[1] < $small )
    {
        next ;
    }
    $bs{$data[0]}=$data[1];
}

$used=0;
$barcode_num1=0;
foreach my $key ( keys %bs ){
    $index=$barcode_num1/8;
    print OUT "$key\t$wb[$index]\t$bs{$key}\n";
    $barcode_num1 ++ ;
    $used+=$bs{$key};
    if( $index >= $barcode_num)
    {
        last ;
    }
}

print "Total $total pairs and used $used pairs  \n";
close(IN);
close(OUT);
