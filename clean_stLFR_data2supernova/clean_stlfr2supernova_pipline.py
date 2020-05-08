import argparse
import os
parser = argparse.ArgumentParser()
parser.add_argument('-r1', help='stlfr clean reads1', required=True, type=str)
parser.add_argument('-r2', help='stlfr clean reads2', required=True, type=str)
parser.add_argument('-supernova', help='supernova soft path', required=True, type=str)
parser.add_argument('-o', help='output folder(no exist before)', required=False, type=str)
parser.add_argument('-f', help='filter less X pair barcode reads(default = 2)', required=False, type=str)
parser.add_argument('-m', help='mapping ratio (default=8)', required=False, type=str)
parser.add_argument('-s', help='soft path', required=True, type=str)
args = parser.parse_args()
if args.o:
    os.system('mkdir ' + args.o)
if args.r1:
    if '/' in args.r1:
        os.system('ln -s ' + args.r1 + ' split_reads.1.fq.gz.clean.gz')
        os.system('ln -s ' + args.r2 + ' split_reads.2.fq.gz.clean.gz')
    else:
        os.system('ln -s ' + args.r1 + ' split_reads.1.fq.gz.clean.gz')
        os.system('ln -s ' + args.r2 + ' split_reads.2.fq.gz.clean.gz')
os.system('/bin/sh ' + args.s + 'shell_barcode')
if args.f:
    filter_num = args.f
else:
    filter_num = 2
if args.m:
    mapratio_num = args.m
else:
    mapratio_num = 8
wl = args.supernova + '/supernova-cs/*/tenkit/lib/python/tenkit/barcodes/4M-with-alts-february-2016.txt'
os.system('perl ' + args.s + 'merge_barcodes.pl barcode_clean_freq.txt ' + wl + ' merge.txt ' + str(filter_num) + ' ' + str(mapratio_num) +' 1> merge_barcode.log  2>merge_barcode.err')
os.system('perl ' + args.s + 'fake_10x.pl ' + args.r1 + ' ' + args.r2 + ' merge.txt >fake_10X.log 2>fake_10X.err')
os.system('mv read-I1_si-TTCACGCG_lane-001-chunk-001.fastq.gz ' + args.o + '/sample_S1_L001_I1_001.fastq.gz')
os.system('mv read-R1_si-TTCACGCG_lane-001-chunk-001.fastq.gz ' + args.o + '/sample_S1_L001_R1_001.fastq.gz')
os.system('mv read-R2_si-TTCACGCG_lane-001-chunk-001.fastq.gz ' + args.o + '/sample_S1_L001_R2_001.fastq.gz')
os.system('mv *.log ' + args.o)
os.system('mv *.err ' + args.o)
print('fake over')
os.system(args.supernova + 'supernova run --id=supernova_out --maxreads=2140000000  --fastqs=' + args.o + ' --accept-extreme-coverage --localcores=8 --localmem=500 --nopreflight 1>_log 2>_err')
os.system(args.supernova + 'supernova mkoutput --style=pseudohap --asmdir=supernova_out/outs/assembly --outprefix=xiaoqiang_supernova_result')
print('pip line over')
