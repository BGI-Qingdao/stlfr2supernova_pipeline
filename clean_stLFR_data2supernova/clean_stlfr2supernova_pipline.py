import argparse
import os
import time
###############################################
# parse parameters
###############################################
parser = argparse.ArgumentParser()
parser.add_argument('-r1', help='stlfr clean reads1', required=True, type=str)
parser.add_argument('-r2', help='stlfr clean reads2', required=True, type=str)
parser.add_argument('-supernova', help='supernova soft path', required=True, type=str)
parser.add_argument('-o', help='output folder(no exist before)', required=False, type=str)
parser.add_argument('-f', help='filter less X pair barcode reads(default = 2)', required=False, type=str)
parser.add_argument('-m', help='mapping ratio (default=8)', required=False, type=str)
parser.add_argument('-t', help='threads for supernova(default 8)', required=False, type=int)
parser.add_argument('-M', help='memory(GB) for supernova(default 100)', required=False, type=int)
parser.add_argument('-s', help='soft path', required=True, type=str)
args = parser.parse_args()
# fill default values if necessary
if args.f:
    filter_num = args.f
else:
    filter_num = 2
    
if args.m:
    mapratio_num = args.m
else:
    mapratio_num = 8

if args.t:
    CPU = args.t
else:
    CPU = 8
    
if args.M:
    MEM = args.M
else:
    MEM = 100
    
###############################################
# prepare datas and folder
###############################################
# check realpath 
if args.r1:
    r1path = os.path.realpath(args.r1)
    r2path = os.path.realpath(args.r2)
# create folder
if args.o:
    os.system('mkdir -p ' + args.o)
    # switch into output folder now
    os.chdir(args.o)
# link input reads
os.system('ln -sf ' + r1path + ' split_reads.1.fq.gz.clean.gz')
os.system('ln -sf ' + r2path + ' split_reads.2.fq.gz.clean.gz')
# whitelist in supernova folder
wl = args.supernova + '/supernova-cs/*/tenkit/lib/python/tenkit/barcodes/4M-with-alts-february-2016.txt'
###############################################
# main pipeline
###############################################
# generate barcode.freq     
os.system('/bin/sh ' + args.s + 'shell_barcode')
# generate barcode mapping table     
os.system('perl ' + args.s + 'merge_barcodes.pl barcode_clean_freq.txt ' + wl + ' merge.txt ' + str(filter_num) + ' ' + str(mapratio_num) +' 1> merge_barcode.log  2>merge_barcode.err')
# convert file format     
os.system('perl ' + args.s + 'fake_10x.pl  split_reads.1.fq.gz.clean.gz  split_reads.2.fq.gz.clean.gz  merge.txt  >fake_10X.log 2>fake_10X.err')
# rename fastqs 
os.system('mkdir -p supernova_in')
os.system('mv read-I1_si-TTCACGCG_lane-001-chunk-001.fastq.gz  supernova_in/sample_S1_L001_I1_001.fastq.gz')
os.system('mv read-R1_si-TTCACGCG_lane-001-chunk-001.fastq.gz  supernova_in/sample_S1_L001_R1_001.fastq.gz')
os.system('mv read-R2_si-TTCACGCG_lane-001-chunk-001.fastq.gz  supernova_in/sample_S1_L001_R2_001.fastq.gz')
print('fake over')
if os.path.exists('./supernova_out'):
    os.system('mkdir -p prev_run')
    os.system('mv supernova_out prev_run/supernova_out'+str(int(time.time()))+' ')
# run supernova 
os.system(args.supernova + 'supernova run --id=supernova_out --maxreads=2140000000  --fastqs=./supernova_in/ --accept-extreme-coverage --localcores='+ str(int(CPU)) +' --localmem=' + str(int(MEM)) + ' --nopreflight 1>_log 2>_err')
os.system(args.supernova + 'supernova mkoutput --style=pseudohap --asmdir=supernova_out/outs/assembly --outprefix=xiaoqiang_supernova_result')
print('pip line over')
