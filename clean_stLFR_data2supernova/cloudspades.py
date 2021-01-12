import argparse
import os
from Step import step_1_convert10X
from Step import step_2_run_longranger
from Step import step_5_run_clouspades
parser = argparse.ArgumentParser()
parser.add_argument('-longranger_out', help='longranger out path', required=False, type=str)
parser.add_argument('-r1', help='stlfr clean reads1', required=True, type=str)
parser.add_argument('-r2', help='stlfr clean reads2', required=True, type=str)
parser.add_argument('-o', help='output folder(no exist before)', required=False, type=str)
parser.add_argument('-cloudspades', help='cloudspades path', required=False, type=str)
parser.add_argument('-supernova', help='supernova path', required=False, type=str)
parser.add_argument('-longranger', help='longranger path', required=False, type=str)
parser.add_argument('-f', help='filter less X pair barcode reads(default = 2)', required=False, type=str)
parser.add_argument('-m', help='mapping ratio (default=8)', required=False, type=str)
parser.add_argument('-s', help='soft path', required=True, type=str)
args = parser.parse_args()
# run supernova 1.3
# run athena 1,2,4
# run cloudspades 1,2,5
environment = str(args.s) + '/cloudspades_environment.sh'
os.system('source ' + environment)
if args.longranger_out:
    if args.cloudspades:
        step_5_run_clouspades.run_cloudspades(longranger_out=args.longranger_out,
                                              cloudspades_path=args.cloudspades)
    else:
        step_5_run_clouspades.run_cloudspades(longranger_out=args.longranger_out)
else:
    if args.cloudspades:
        step_1_convert10X.convert10X(r1=args.r1, r2=args.r2, filter_num=args.f, mapratio_num=args.m, o=args.o,
                                     soft=args.s)
        step_2_run_longranger.run_longranger(fastq_path=args.o)
        step_5_run_clouspades.run_cloudspades(longranger_out='longranger/outs',
                                              cloudspades_path= args.cloudspades)
    else:
        step_1_convert10X.convert10X(r1=args.r1, r2=args.r2, filter_num=args.f, mapratio_num=args.m, o=args.o,
                                     soft=args.s)
        step_2_run_longranger.run_longranger(fastq_path=args.o)
        step_5_run_clouspades.run_cloudspades(longranger_out='longranger/outs')

