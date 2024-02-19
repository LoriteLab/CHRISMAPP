# CHRISMAPP
R script to annotate sequences (e.g. SatDNA) in chromosome-level assemblies.


The pipeline needs an annotation step made in Geneious prime. The similarity we recommend is around 70% for SatDNA families. You must to export a .gff file with only the annotations.
Then you only need to run this script in R, providing also a .txt file containing chromosome names and the length of each one for plotting.
