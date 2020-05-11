 if your stLFR data are split split barcode & remove PCR dup and filter adaptor.you can use this pipline.
  1.Download this folder
  2.your reads must be compression（.gz）
  2.use python3 to run clean_stlfr2supernova_pipline.py
  you will have this usage:
  
  usage: clean_stlfr2supernova_pipline.py  [-h]  -r1  R1  -r2  R2  -supernova
  optional arguments:
  -h, --help            show this help message and exit
  
  -r1 R1                stlfr clean reads1
  
  -r2 R2                stlfr clean reads2
  
  -supernova SUPERNOVA  supernova soft path
  
  -o O                  output folder(no exist before)
  
  -f F                  filter less X pair barcode reads(default = 2)
  
  -m M                  mapping ratio (default=8)
  
  -s S                  soft path

fill in the parameters to run.

example:
python3 clean_stlfr2supernova_pipline.py -r1 stlfr_1.fq.gz -2 stlfr_2.fq.gz -supernova path/supernova/ -s path_to_this_program/folder -o log_out 
