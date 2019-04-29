#/bin/bash

if [[ $# != 3 ]] ; then 
    echo "Usage : $0 your-barcode-freq.txt your-genome-size(in bp)  your-expect-cov"
    echo "please check your parameters .exit ... "
    exit 1
fi

BarcodeFreq=$1
GenomeSize=$2
ExpectCov=$3

if [[ ! -f $BarcodeFreq ]] ; then 
    echo "Usage : $0 your-barcode-freq.txt your-genome-size(in bp)  your-expect-cov"
    echo "your-barcode-freq.txt [ $BarcodeFreq ] is not exist !!! "
    echo "exit ..."
    exit 1
fi

echo "INFO : run with BarcodeFreq=$BarcodeFreq GenomeSize=$GenomeSize ExpectCov=$ExpectCov "
ExpectBP=$((GenomeSize*ExpectCov))
ExpectReadPair=$((ExpectBP/200))
TMP=tmp.pair_num_per_barcode_freq.txt
echo "INFO : expect reads_pair=$ExpectReadPair"

awk '{print $2}' < $BarcodeFreq | sort -n | uniq -c | \
    awk 'BEGIN{a=0;}{ freq=$1; pair_num=$2; if( pair_num != 0 ) { a=a+freq*pair_num; printf("%d\t%d\t%d\t%d\n",freq,pair_num,freq*pair_num,a) ; } }' \
    >$TMP

TotalPair=`awk 'BEGIN{a=0;}{a=a+$3;}END{print a;}' <$TMP`
echo "INFO : total reads_pair=$TotalPair"

if [[ $TotalPair -lt $ExpectReadPair ]] ; then 
    echo "FATAL : total < expect !! no need for filter !!! exit ..."
    exit 1
fi

BIG=1
BigPair=`awk 'BEGIN{a=0;}{if($2>$BIG) { a=a+$3;} } END {print a; }'  <$TMP`
echo "INFO : delete barcode with too mush reads : big_pair=$BigPair"

LeftPair=$((TotalPair-BigPair))
if [[ $LeftPair -lt $ExpectReadPair ]] ; then 
    echo "RESULT : high threshold is $BIG and low threshold is 1"
    echo "RESULT : delete $BigPair reads total."
    echo "Done ..."
    exit 0
fi

NeedCut=$((LeftPair-ExpectReadPair))
echo "{if( \$4 > $NeedCut) { print \$0;} }" >tmp.awk
awk  -f tmp.awk  <$TMP | head -n  1  1>tmp.low.result
LOW=`awk '{print $2}' <tmp.low.result`
Low_the_pair=`awk '{print $3}' <tmp.low.result`
LowPair=`awk '{print $4}' <tmp.low.result`

NowLeftPair=$((LeftPair- LowPair))
echo "RESULT : high threshold is $BIG and low threshold is $((LOW+1))"
echo "RESULT : delete $BigPair from barcodes that contain reads-pair > $BIG."
echo "RESULT : delete $LowPair from barcodes that contain reads-pair < $((LOW+1))."
echo "RESULT : left $NowLeftPair reads = $((NowLeftPair/GenomeSize)) cov"
echo "Done ..."
