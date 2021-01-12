import os
def run_cloudspades(longranger_out,
                    cloudspades_path='/dellfsqd2/ST_OCEAN/USER/gushengqiang/project/software/cloudspades/bin'):
    os.system(
        str(cloudspades_path) + '/spades.py --gemcode1-12 ' + str(
            longranger_out) + '/barcoded.fastq.gz  -o cloudspades_out -t 16 -m 800')
    print('step 5 cloudspades over')
