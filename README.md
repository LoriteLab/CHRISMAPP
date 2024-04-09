# CHRISMAPP
R script to annotate sequences (e.g. SatDNA) in chromosome-level assemblies.


The pipeline needs an annotation step made in Geneious. The similarity we recommend is around 70% for SatDNA families. You must to export a .gff file with only the annotations.
Then you only need to run this script in R, providing also a .txt file containing chromosome names and the length of each one for plotting.


# CHRISMAPP.v2

A revised version of this script has been introduced, incorporating the following enhancements:

  Elimination of the requirement for a .txt file containing chromosome names and sizes. Instead, this updated script retrieves chromosome length data directly from the Geneious .gff file.
  Integration of a feature enabling the generation of a new PDF file that consolidates all individual annotation graphs.


    #####################  THANKS FOR USING ChrIsMapp script #######################
    ##################### please if you use it cite our paper ######################

Rico-Porras, J.M.; Mora, P.; Palomeque, T.; Montiel, E.E.; Cabral-de-Mello, D.C.; Lorite, P. Heterochromatin Is Not the Only Place for satDNAs: The High Diversity of satDNAs in the Euchromatin of the Beetle Chrysolina americana (Coleoptera, Chrysomelidae). Genes 2024, 15, 395. https://doi.org/10.3390/genes15040395
