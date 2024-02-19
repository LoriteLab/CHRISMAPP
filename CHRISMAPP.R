#####################  THANKS FOR USING ChrIsMapp script ##############################

##################### please if you use it cite our paper XXXXXX ######################

# BEFORE NOTHING, PLEASE PREPARE THE TXT FILE CONTAINING THE CHROMOSOME LENGTH INFO
# WITH COLUMNS NAMED AS "Chromosome" AND "Length"


# before loading install the libraries if you do not have them 
# Load the libraries

library(readr)
library(ggplot2)
library(dplyr)
library(rtracklayer)


# set the working directory where the archives are 

# read and import the gff file, change the name as the same you have stored the data

gff_file <- "name.gff"

gff <- import(gff_file)

# erase lines with #

gff <- gff[!grepl("^#", gff$line), ]

# read txt file containing name of chromosomes and size

chromosome_size <- "chromosome_size.txt"

chrom_table <- read.table(chromosome_size, header = TRUE)

# adding col names "NU will not be taken (Not Useful)
cols <- c("Chromosome", "NU", "Type", "Start", "Final", "NU2", "NU3", "NU4", "NU5")
df <- read.table(gff_file, sep="\t", col.names=cols, stringsAsFactors=FALSE)

# create a new df with the initial "AA" annotations for chromosome limits
annotations <- data.frame(
  Chromosome = unique(df$Chromosome),  
  NU = NA,  
  Type = "AA",
  Start = 1,
  Final = 2,
  NU2 = NA,
  NU3 = NA,
  NU4 = NA,
  NU5 = NA
)

# combine the new df with the old one
df <- bind_rows(df, annotations)

# Order by chromosome and start position
df <- df %>% arrange(Chromosome, Start)

# create a new df with the final "AA" annotations for chromosome limits
annotations_final <- data.frame(
  Chromosome = chrom_table$Chromosome,  
  NU = NA,  
  Type = "AA",
  Start = chrom_table$Length - 1,  
  Final = chrom_table$Length,      
  NU2 = NA,
  NU3 = NA,
  NU4 = NA,
  NU5 = NA
)

# combine new and old dfs
df <- bind_rows(df, annotations_final)

# # Order by chromosome and start position
df <- df %>% arrange(Chromosome, Start)

# write and save the new gff file
write.table(df, file = "Annotation_with_chromosome_limits.gff", sep = "\t", quote = FALSE, row.names = FALSE)

# Obtain chromosome sizes 
chromosome_length <- df[df$Type == "AA", c("Chromosome", "Start", "Final")]
chromosome_length$Start <- as.integer(chromosome_length$Start)
chromosome_length$Final <- as.integer(chromosome_length$Final)

# Limits for each chromosome
chromosome_limits <- chromosome_length %>%
  group_by(Chromosome) %>%
  summarise(Start = min(Start), Final = max(Final))

# Chose your color palette, customize as you may need
colors <- c("#ff2b2b", "#f6fa73", "#35c7fc", "#00a611", "#ff38ca", "#90A4AE", "#A1887F", "#FFEB3B", "#18FFFF", "#B2FF59", "#FF9E80")

# chromosome wide
chrom_wide <- 1  

# Annotation wide 
annot_wide <- 10

# lets plot in vertical
p_vertical <- ggplot() +
  geom_segment(data=chromosome_limits, aes(x=Chromosome, xend=Chromosome, y=Start, yend=Final), color="black", size=chrom_wide) +
  geom_segment(data=df[df$Type != "AA", ], aes(x=Chromosome, xend=Chromosome, y=Start, yend=Final, color=Type), size=annot_wide) +
  scale_color_manual(values = colors) +
  labs(x="Chromosome", y="Position", title="Annotation") +
  theme_minimal() +
  theme(legend.position="right", axis.text.x = element_text(size = 10, angle = 45, vjust = 0.5), panel.grid = element_blank())  

# save in high quality png image
ggsave("CHRISMAPP_vertical.png", p_vertical, width = 12, height = 18, dpi = 1200) 

# save in high quality pdf file
ggsave("chromosomes_annotated_vertical.pdf", plot = p_vertical, width = 210, height = 297, units = "mm")

# thanks
cat("Thank you for using this code. Please cite our work.")

####################### USE THE CODE BELOW IF YOU WISH TO PLOT IN HORIZONTAL ####################### 

# lets plot in horizontal
p_horizontal <- ggplot() +
  geom_segment(data=chromosome_limits, aes(x=Start, xend=Final, y=Chromosome, yend=Chromosome), color="black", size=chrom_wide) +
  geom_segment(data=df[df$Type != "AA", ], aes(x=Start, xend=Final, y=Chromosome, yend=Chromosome, color=Type), size=annot_wide) +
  scale_color_manual(values = colors) +
  labs(x="Position", y="Chromosome", title="Annotation") +
  theme_minimal() +
  theme(legend.position="right", axis.text.x = element_text(size = 10, angle = 0, hjust = 0.5), panel.grid = element_blank())  

# save in high quality png image
ggsave("CHRISMAPP_horizontal.png", p_horizontal, width = 12, height = 18, dpi = 1200) 

# save in high quality pdf file
ggsave("chromosomes_annotated_horizontal.pdf", plot = p_horizontal, width = 297, height = 210, units = "mm")

# thanks
cat("Thank you for using this code. Please cite our work.")
