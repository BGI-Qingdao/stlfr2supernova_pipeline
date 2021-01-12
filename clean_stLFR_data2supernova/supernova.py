import os
import argparse
from Step import step_1_convert10X
from Step import step_3_run_supernova
parser = argparse.ArgumentParser()
parser.add_argument('-r1', help='stlfr clean reads1', required=True, type=str)
parser.add_argument('-r2', help='stlfr clean reads2', required=True, type=str)
parser.add_argument('-supernova', help='supernova soft path', required=False, type=str)
parser.add_argument('-o', help='output folder(no exist before)', required=False, type=str)
parser.add_argument('-f', help='filter less X pair barcode reads(default = 2)', required=False, type=str)
parser.add_argument('-m', help='mapping ratio (default=8)', required=False, type=str)
parser.add_argument('-s', help='soft path', required=True, type=str)
args = parser.parse_args()
# run supernova 1.3
# run athena 1,2,4
# run cloudspades 1,2,5
if args.supernova:
    step_1_convert10X.convert10X(r1=args.r1, r2=args.r2, filter_num=args.f, mapratio_num=args.m, o=args.o, soft=args.s,
                                 supernova=args.supernova)
    step_3_run_supernova.run_supernova(args.o, supernova=args.supernova)
else:
    step_1_convert10X.convert10X(r1=args.r1, r2=args.r2, filter_num=args.f, mapratio_num=args.m, o=args.o, soft=args.s)
    step_3_run_supernova.run_supernova(args.o)



