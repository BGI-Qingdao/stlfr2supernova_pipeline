 if your stLFR data are split split barcode & remove PCR dup and filter adaptor.you can use this pipline.<br>
  1.Download this folder<br>
  2.your reads must be compression（.gz）<br>
  3.use python3 to run clean_stlfr2supernova_pipline.py<br> 
  `you will have this usage:<br> 
   >usage: clean_stlfr2supernova_pipline.py   [-h]   -r1   R1   -r2  -R2   -supernova<br>
   >optional arguments:<br>
  >>-h, --help            show this help message and exit<br>
  >>-r1 R1                stlfr clean reads1<br>
  >>-r2 R2                stlfr clean reads2<br>
  >>-supernova SUPERNOVA  supernova soft path<br>
  >>-o O                  output folder(no exist before)<br>
  >>-f F                  filter less X pair barcode reads(default = 2)<br>
  >>-m M                  mapping ratio (default=8)<br>
  >>-s S                  soft path<br>`

fill in the parameters to run.
example:<br>
python3 clean_stlfr2supernova_pipline.py -r1 stlfr_1.fq.gz -2 stlfr_2.fq.gz -supernova path/supernova/ -s path_to_this_program/folder -o log_out <br>
