#!/usr/bin/perl

print "Merge stLFR reads into 10X format !\n read1 :  $ARGV[0] \n. read2 : $ARGV[1] \n map file : $ARGV[2]";
open IN3,$ARGV[2] ;
$barcode_num=1;
while(<IN3>)
{
    chomp;
    my @pair =split(/\t/,$_);
    $map{$pair[0]}=$pair[1] ;
}
close IN3;

open IN1,"gzip -dc $ARGV[0] | ";
open IN2,"gzip -dc $ARGV[1] | ";
open OUT,"| gzip > read-RA_si-TTCACGCG_lane-001-chunk-001.fastq.gz";
open OUT2,"| gzip > read-I1_si-TTCACGCG_lane-001-chunk-001.fastq.gz";

$N=0;
while(<IN1>)
{
    chomp;
    my @line=split(/\t/, $_);
    my @name=split(/\#/, line[0]);
    if( ! exists($map{$name[1]} ) )
    {
        $S=<IN1>;
        $S=<IN1>;
        $S=<IN1>;

        $S=<IN2>;
        $S=<IN2>;
        $S=<IN2>;
        $S=<IN2>;

        next;
    }
    else
    {
        $barcode = $map{$name[1]};
    }

    $N++;
    $seq="\@ST-E0:0:SIMULATE:8:0:0:$N";
    ## 1th
    print OUT "$seq 1:N:0\n";
    ## 2th
    $S=<IN1>;
    print OUT "$barcode"."ATCGAGA"."$S";
    #                     1234567
    ## 3th
    $S=<IN1>;
    print OUT "$S";
    ## 4th
    $S=<IN1>;
    $S=~s/!/#/g;
    print OUT "FFFFFFFFFFFFFFFFFFFFFFF$S";
    # 16+7=23  12345678901234567890123
    ## 1th
    $S=<IN2>;
    print OUT"$seq 3:N:0\n";
    ## 2th
    $S=<IN2>;
    print OUT "$S";
    ## 3th
    $S=<IN2>;
    print OUT "$S";
    ## 4th
    $S=<IN2>;
    $S=~s/!/#/g;
    print OUT "$S";

    print OUT2 "$seq 2:N:0\nTTCACGCG\n\+\nAAFFFKKK\n";
}

close(IN1);
close(IN2);
close(OUT);
close(OUT2);
