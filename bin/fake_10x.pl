#!/usr/bin/perl

#####script from Guo Lidong at BGI, 20180702, modified to print read1 and read2 into seperate files, and named as read 1 and 2, also indexes with names '1' instead of '2' #######
###add file index so that when processing split fastq from same library, reads won't have the same name

###add 16bp barcode and 7bp seq before read1, add sample index at the end of read names
### Guo Lidong re-copy from Mao Qing at BGI , 20181011 . modify that read barcode from barcode string instead of barcode number .

print "Merge stLFR reads into 10X format !\n read1 :  $ARGV[0] \n. read2 : $ARGV[1] \n map file : $ARGV[2]\n";
$|=1;
open IN3,$ARGV[2] or die "failed to open $ARGV[2] for read ";
$barcode_num=1;
while(<IN3>)
{
    chomp;
    my @pair =split(/\t/,$_);
    $map{$pair[0]}=$pair[1] ;
}
close IN3;

open IN1,"gzip -dc $ARGV[0] | " or die "failed to open $ARGV[0] for read ";
open IN2,"gzip -dc $ARGV[1] | "  or die "failed to open $ARGV[1] for read " ;
open OUT,"| gzip > read-R1_si-TTCACGCG_lane-001-chunk-001.fastq.gz" or die "failed to open  read-R1_si-TTCACGCG_lane-001-chunk-001.fastq.gz for write";
open OUT2,"| gzip > read-I1_si-TTCACGCG_lane-001-chunk-001.fastq.gz" or die "failed to open read-I1_si-TTCACGCG_lane-001-chunk-001.fastq.gz for write";
open OUT3,"| gzip > read-R2_si-TTCACGCG_lane-001-chunk-001.fastq.gz" or die "failed to open read-R2_si-TTCACGCG_lane-001-chunk-001.fastq.gz for write";

$N=0;
$line_num=0;
while(<IN1>)
{
    $line_num++;
    if (  $line_num %1000000 == 0)
    {
        $Mr= int($line_num / 1000000);
        print "process $Mr (Mb) pair of reads now  \n";
        $|=1;
    }
    chomp;
    # head looks like : @CL200051332L1C001R001_0#1335_550_1232/2        1       1
    my @line=split(/\t/, $_);
    my @name1=split(/\#/, $line[0]);
    my @name=split(/\//, $name1[1]);
    if( ! exists($map{$name[0]} ) )
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
        $barcode = $map{$name[0]};
    }

    $N++;
    $seq="\@ST-E0:0:SIMULATE:8:0:0:$N";
    ## 1th
    print OUT "$seq 1:N:0:NAAGTGCT\n";
    ## 2th
    $S=<IN1>;
    print OUT "$barcode"."ATCGAGN"."$S";
    ## 3th
    $S=<IN1>;
    print OUT "$S";
    ## 4th
    $S=<IN1>;
    $S=~s/!/#/g;
    print OUT "FFFFFFFFFFFFFFFFFFFFFF#$S";
    #          1234567890123456789012
    ## 1th
    $S=<IN2>;
    print OUT3 "$seq 2:N:0:NAAGTGCT\n";
    ## 2th
    $S=<IN2>;
    print OUT3 "$S";
    ## 3th
    $S=<IN2>;
    print OUT3 "$S";
    ## 4th
    $S=<IN2>;
    $S=~s/!/#/g;
    print OUT3 "$S";

    print OUT2 "$seq 1:N:0:NAAGTGCT\nTTCACGCG\n\+\nAAFFFKKK\n";
}
print "Total $line_num pair reads and used $N pairs.\n";
close(IN1);
close(IN2);
close(OUT);
close(OUT2);
close(OUT3);
