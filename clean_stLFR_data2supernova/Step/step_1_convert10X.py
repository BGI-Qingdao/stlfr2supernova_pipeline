def convert10X(r1, r2, o, soft,filter_num=2, mapratio_num=8,
               supernova='/dellfsqd1/ST_OCEAN/ST_OCEAN/USRS/xumengyang/software/supernova4stLFR/'):
    import os
    if o:
        os.system('mkdir ' + str(o))
    if r1:
        if '/' in r1:
            os.system('ln -s ' + r1 + ' split_reads.1.fq.gz.clean.gz')
            os.system('ln -s ' + r2 + ' split_reads.2.fq.gz.clean.gz')
        else:
            os.system('ln -s ' + r1 + ' split_reads.1.fq.gz.clean.gz')
            os.system('ln -s ' + r2 + ' split_reads.2.fq.gz.clean.gz')
    os.system('/bin/sh ' + str(soft) + '/shell_barcode')
    wl = str(supernova) + '/supernova-cs/*/tenkit/lib/python/tenkit/barcodes/4M-with-alts-february-2016.txt'
    os.system('perl ' + str(soft) + '/merge_barcodes.pl barcode_clean_freq.txt ' + wl + ' merge.txt ' + str(
        filter_num) + ' ' + str(mapratio_num) + ' 1> merge_barcode.log  2>merge_barcode.err')
    os.system('perl ' + str(soft) + '/fake_10x.pl ' + r1 + ' ' + r2 + ' merge.txt >fake_10X.log 2>fake_10X.err')
    os.system('mv read-I1_si-TTCACGCG_lane-001-chunk-001.fastq.gz ' + str(o) + '/sample_S1_L001_I1_001.fastq.gz')
    os.system('mv read-R1_si-TTCACGCG_lane-001-chunk-001.fastq.gz ' + str(o) + '/sample_S1_L001_R1_001.fastq.gz')
    os.system('mv read-R2_si-TTCACGCG_lane-001-chunk-001.fastq.gz ' + str(o) + '/sample_S1_L001_R2_001.fastq.gz')
    os.system('mv *.log ' + str(o))
    os.system('mv *.err ' + str(o))
    print('Step 1 over')
