#!/usr/bin/perl

use strict;
if(@ARGV != 4)
{
    print "#-------------------------------------------------------------------------------\n";
    print "Usage    : perl split_barcode.pl barcode.list r1 r2 output_prefix \n";
    print "Example  : perl split_barcode.pl barcode.list r1.fq.gz r2.fq.gz split_reads \n";
    print "#-------------------------------------------------------------------------------\n";
    exit(0);
}

my @line;

#
# Step 1.
#       0. make barcode fault-tolerant hash
#           that map single barcode to a num ID ;
#

print "step 1 : load barcodes ... \n";
my %barcode_hash;
open IN,"$ARGV[0]" or die "cann't not open barcode.list";
my $index = 0;
while(<IN>)
{
    $index ++;
    my @line = split;
    my @barcode = split(//,$line[0]);
    my $barcode_ID = $line[1];
    for(my $num = 0; $num <= 9; $num++)
    {
        my @barcode_mis = @barcode;
        $barcode_mis[$num] = "A";
        my $barcode_mis = join("",@barcode_mis);
        $barcode_hash{$barcode_mis} = $barcode_ID;
        @barcode_mis = @barcode;
        $barcode_mis[$num] = "G";
        my $barcode_mis = join("",@barcode_mis);
        $barcode_hash{$barcode_mis} = $barcode_ID;
        @barcode_mis = @barcode;
        $barcode_mis[$num] = "C";
        my $barcode_mis = join("",@barcode_mis);
        $barcode_hash{$barcode_mis} = $barcode_ID;
        @barcode_mis = @barcode;
        $barcode_mis[$num] = "T";
        my $barcode_mis = join("",@barcode_mis);
        $barcode_hash{$barcode_mis} = $barcode_ID;
    }
}
close IN;

my $line_num = 0;
#
# Step 2.
#       0. detect barcodes type from r2
print "step 2 : detect barcodes type from r2 ... \n";
my $n1 = 10;
my $n2 = 6;
my $n3 = 10;
my $n4 = 0;
my $n5 = 10;
my $valid_read_len = 100  ;
my $r2_len = 0 ;
open IN2,"gzip -dc $ARGV[2] |" or die "cannot open file";
while(<IN2>)
{
    chomp;
    @line = split;
    $line_num ++;
    if( $line_num == 2 )
    {
        my $len = length($line[0]);
        $r2_len = $len ;
        if( $len == 154 )
        {
            $n4 = 18 ;
        }
        elsif ( $len == 142 )
        {
            $n4 = 6 ;
        }
        elsif ( $len == 126 )
        {
            $n4 = 0 ;
            $n5 = 0;
        }
        else
        {
            print "Unknow read len of r2 : $len . Please double check the $ARGV[2] file.";
            exit(0);
        }
        last;
    }
}
close IN2 ; 

my $barcode_types = $index * $index *$index;
my $barcode_each = $index;

#   Step 3
#       1. make line_num --> barcode_string map.
#       2. make barcode_string --> barcode_num map.
#       3. make barcode_num --> barcode_string map.
#       4. calculate barcode_num frequence .
#       5. print stats.

my %line_num_2_barcode_str_hash;
my %barcode_str_2_num_hash;
my %barcode_num_2_str_hash;
my %barcode_freq_hash;

$barcode_str_2_num_hash{"0_0_0"} = 0;
$barcode_num_2_str_hash{0} = "0_0_0";

my $reads_num = 0;
my $split_reads_num = 0 ;
my $split_barcode_num = 0;
my $progress = 0 ;

print "step 3 : check barcodes from read2 .... \n";
open IN2,"gzip -dc $ARGV[2] |" or die "cannot open file";
$line_num = 0;
while(<IN2>)
{
    chomp;
    @line = split;
    $line_num ++;
    # print process ...
    if($line_num % 4 == 1)
    {
        $reads_num ++;
        if($line_num % 4000000 == 1)
        {
            print "check barcodes processed $progress (M) reads ...\n";
            $progress ++ ;
        }
    }

    # check barcodes 
    if($line_num % 4 == 2)
    {
        my $b1 = substr($line[0], $valid_read_len, $n1);
        my $b2 = substr($line[0], $valid_read_len+$n1+$n2, $n3);
        my $b3 = substr($line[0], $valid_read_len+$n1+$n2+$n3+$n4, $n5);
        if((exists $barcode_hash{$b1}) && (exists $barcode_hash{$b2}) && ($n5 != 0 && (exists $barcode_hash{$b3})) )
        {
            my $str = $barcode_hash{$b1}."_".$barcode_hash{$b2};
            if( $n5 != 0 )
            {
                $str = $str."_".$barcode_hash{$b3};
            }
            if(!(exists $barcode_str_2_num_hash{$str})) {
                $split_barcode_num ++;
                $barcode_str_2_num_hash{$str} = $split_barcode_num;
                $barcode_num_2_str_hash{$split_barcode_num} = $str;
                $barcode_freq_hash{$str} = 0;
            }
            $split_reads_num ++;
            $barcode_freq_hash{$str} ++;
            my $head_num = $line_num -1 ;
            $line_num_2_barcode_str_hash{$head_num} = $str ;
        }
        else
        {
            my $head_num = $line_num -1 ;
            $line_num_2_barcode_str_hash{$head_num} = "0_0_0";
        }
    }
}
# print stat
my $r1 = 0 ;
my $r2 = 0 ;
$r1 = 100 *  $split_barcode_num/$barcode_types;
$r2 = 100 *  $split_reads_num/$reads_num;
open OUT, ">split_stat_read.log" or die "ERROR : Can't open split_stat_read.log for write \n";
print OUT "Barcode_types = $barcode_each * $barcode_each * $barcode_each = $barcode_types\n";
print OUT "Real_Barcode_types = $split_barcode_num ($r1 %)\n";
print OUT "Reads_pair_num  = $reads_num \n";
print OUT "Reads_pair_num(after split) = $split_reads_num ($r2 %)\n";
print OUT "read2_read_len : $r2_len \n";
print OUT "barcode type : $valid_read_len-$n1-$n2-$n3-$n4-$n5 \n";
close OUT;
#print barcode details 
open  OUT1, ">barcode_freq.txt" or die "ERROR : Can't open barcode_freq.txt for write !!! \n";
print OUT1 "bacode_str\tbarcode_count\tbarcode_num\n";
for(my $i=1;$i<=$split_barcode_num;$i++){
    my $str = $barcode_num_2_str_hash{$i} ;
    print OUT1 "$str\t$barcode_freq_hash{$str}\t$i\n";
}
close OUT1;

#
# Step 4 . parse r1 line by line .
#
print "step 4 : parse read 1 ...\n";
open IN_r1,"gzip -dc $ARGV[1] |" or die "cannot open $ARGV[1] for read \n";
open OUT_r1, "| gzip > $ARGV[3].1.fq.gz" or die "Can't open $ARGV[3].1.fq.gz for write";

$line_num = 0 ;
$progress = 0 ;
while(<IN_r1>)
{
    chomp;
    $line_num ++ ;
    # print process ...
    my @line = split;
    if( $line_num % 4 == 1 )
    {
        my @A  = split(/\//,$line[0]);
        my $id = $A[0];
        my $str = $line_num_2_barcode_str_hash{$line_num} ; 
        print OUT_r1 $id."\#$str\/1\t$barcode_str_2_num_hash{$str}\t1\n";
        if($line_num% 4000000 == 1)
        {
            print "parse read 1 processed $progress (M) reads ...\n";
            $progress ++ ;
        }
    }
    else
    {
        print OUT_r1 "$line[0]\n";
    }
}
close IN_r1 ;
close OUT_r1 ;
#
# Step 5 . parse r5 line by line .
#

print "step 5 : parse read 2 ...\n";
open IN_r2,"gzip -dc $ARGV[2] |" or die "cannot open $ARGV[2] for read \n";
open OUT_r2, "| gzip > $ARGV[3].2.fq.gz" or die "Can't open $ARGV[3].2.fq.gz for write \n";
$line_num = 0 ;
$progress= 0 ;
while(<IN_r2>)
{
    chomp;
    $line_num ++ ;
    my @line = split;
    if( $line_num % 4 == 1 )
    {
        my @A  = split(/\//,$line[0]);
        my $id = $A[0];
        my $str = $line_num_2_barcode_str_hash{$line_num} ; 
        print OUT_r2  $id."\#$str\/2\t$barcode_str_2_num_hash{$str}\t1\n";
        if($line_num % 4000000 == 1)
        {
            print "parse read 1 processed $progress (M) reads ...\n";
            $progress ++ ;
        }
    }
    else
    {
        if ( $line_num % 4 != 3 )
        {
            my $read = substr($line[0], 0 , $valid_read_len);
            print OUT_r2 "$read\n";
        }
        else
        {
            print OUT_r2 "$line[0]\n"
        }
    }

}
close IN_r2 ;
close OUT_r2 ;

print "all done!\n";
