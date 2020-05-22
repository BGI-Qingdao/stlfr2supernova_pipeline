#!/usr/bin/perl
use strict;

my $argc_num = @ARGV;

if ( $argc_num != 2 ) {
    print "Usage:\n";
    print "stlfr2barcode_fq_gz split.reads.1.fq.gz split.reads.2.fq.gz\n";
    exit -1 ;
}

open IN1,"gzip -dc $ARGV[0] | " or die "failed to open $ARGV[0] for read ";
open IN2,"gzip -dc $ARGV[1] | "  or die "failed to open $ARGV[1] for read " ;

my $N=0;
my $S="";
my $seq="";
my $line_num=0;
while(<IN1>)
{
    $line_num++;
    if (  $line_num %1000000 == 0)
    {
        my $Mr= int($line_num / 1000000);
        print STDERR "process $Mr (Mb) pair of reads now  \n";
    }
    chomp;
    # head looks like : @CL200051332L1C001R001_0#1335_550_1232/2        1       1
    my @line=split(/\t/, $_);
    my @name1=split(/\#/, $line[0]);
    my @name=split(/\//, $name1[1]);
    my $barcode = $name[0];
    my $tenX_barcode="";
    if ( $barcode != "0_0_0" )
    {
        $tenX_barcode=" BX:Z:$barcode-1"
    }
    $seq="\@ST-E0:0:SIMULATE:8:0:0:$N$tenX_barcode";
    ## 1th
    print "$seq\n";
    ## 2th
    $S=<IN1>;
    print "$S";
    ## 3th
    $S=<IN1>;
    print "$S";
    ## 4th
    $S=<IN1>;
    $S=~s/!/#/g;
    print "$S";
    ## 1th
    $S=<IN2>;
    print "$seq\n";
    ## 2th
    $S=<IN2>;
    print "$S";
    ## 3th
    $S=<IN2>;
    print "$S";
    ## 4th
    $S=<IN2>;
    $S=~s/!/#/g;
    print "$S";

    $N++;

}
print STDERR "All Done with $line_num read-pair processed!\n"
