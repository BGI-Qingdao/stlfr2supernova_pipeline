def run_supernova(out, supernova='/dellfsqd1/ST_OCEAN/ST_OCEAN/USRS/xumengyang/software/supernova4stLFR/'):
    import os
    os.system(
        str(supernova) + 'supernova run --id=supernova_out --maxreads=2140000000  --fastqs=' + str(
            out) + ' --accept-extreme-coverage --localcores=8 --localmem=300 --nopreflight 1>_log 2>_err')
    os.system(
        str(
            supernova) + 'supernova mkoutput --style=pseudohap --asmdir=supernova_out/outs/assembly '
                         '--outprefix=supernova_result')
    print('step 3 supernova over')
