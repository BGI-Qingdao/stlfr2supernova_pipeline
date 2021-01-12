import os
def run_athena(spades_path, longranger_out):
    os.system(str(spades_path) + '/metaspades.py --12 ' + str(longranger_out) + '/barcoded.fastq.gz  '
                                                                           '-o metaspades/out')
    os.system('bwa index metaspades/out/contigs.fasta')
    os.system(
        'bwa mem -C -p metaspades/out/contigs.fasta ' + str(
            longranger_out) + '/barcoded.fastq.gz | samtools sort -o align-reads.metaspades-contigs.bam -')
    os.system('gunzip ' + str(longranger_out) + '/barcoded.fastq.gz')
    os.system('samtools index align-reads.metaspades-contigs.bam')
    with open('config.json', 'w') as file:
        file.write('{ \n')
        file.write('    "input_fqs": ' + '"'+str(longranger_out) + '/barcoded.fastq",\n')
        file.write('    "ctgfasta_path": "metaspades/out/contigs.fasta",\n')
        file.write('    "reads_ctg_bam_path": "./align-reads.metaspades-contigs.bam"\n')
        file.write('}')
    os.system('nohup athena-meta --config ./config.json --threads 16 &')
    print('step 4 athena over')