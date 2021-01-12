import os
def run_longranger(fastq_path,
                   longranger_path='/dellfsqd1/ST_OCEAN/ST_OCEAN/USRS/xumengyang/software/longranger4stLFR/'):
    os.system(str(longranger_path) + 'longranger basic --localcores=16 --localmem=300 --id=longranger --fastqs=' + str(fastq_path) + '/')
    print('ster 2 over')
