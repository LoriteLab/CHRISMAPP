#####################  THANKS FOR USING CHRISMAPP script ##############################

############# please if you use it cite our paper Rico-Porras et. al 2024 #############


# before loading install the libraries if you do not have them 
# Load the libraries
library(data.table)
library(ggplot2)
library(dplyr)


# set the working directory where the archives are


# read and import the gff file, change the name as the same you have stored the data

file_gff <- "name.gff"


# Extracting data from gff

lines <- readLines(file_gff)
annotations <- lapply(lines, function(line) {
  if (!startsWith(line, "##")) {
    fields <- strsplit(line, "\t")[[1]]
    if (length(fields) == 9) {
      data.frame(Chr = fields[1], Start = as.numeric(fields[4]), End = as.numeric(fields[5]), Feature = fields[3])
    }
  }
})
annotations <- do.call(rbind, annotations)


# Filter only the lines that start with "##sequence-region"

lines_length <- lines[grep("^##sequence-region", lines)]


# Extract the length information of each chromosome

lengths <- lapply(lines_length, function(line) {
  fields <- unlist(strsplit(line, "\t"))
  chromosome <- fields[2]
  length <- as.numeric(fields[4])
  data.frame(Chr = chromosome, Length = length)
})


# Combine the results into a single data frame.
lengths <- do.call(rbind, lengths)



# Sort the data according to the type of annotation

ordered_data <- arrange(annotations, Feature)


# Extract unique annotation types and assign colors to them 

type_annotations <- unique(ordered_data$Feature)

# You need to ensure that the number of chosen colors in HEX format is at least the total number of unique annotations (typically, the number of annotated satDNA families).

colors_annotations <- c("#a5cee2", "#82b7d6", "#5fa0ca",
                        "#3a8abd", "#257cb2", "#4b97a7", "#72b19c", "#9acd92",
                        "#a4d981", "#85c867", "#63b850", "#43a737", "#4fa03a", "#839c58", 
                        "#b89a74", "#ec9991", "#f58181", "#f06060", "#e83e3f", 
                        "#e31d1e", "#e8412f", "#f06c45", "#f6985b", "#febd6d", 
                        "#fdac50", "#fe9b33", "#fe8b16", "#fb820f", "#ed8f47", 
                        "#de9d7f", "#cfabb7", "#bfa4cf", "#a485c0", "#8c66af", 
                        "#73499f", "#835d9a", "#aa9099", "#d0c399", "#f6f599", 
                        "#eedb7f", "#d9af63", "#c58346", "#b15929")

name_colors_annotations <- setNames(colors_annotations, type_annotations)


#Add a new column "Color" to ordered_data

ordered_data$Color <- name_colors_annotations[ordered_data$Feature]


#Once all the data has been obtained, we can begin plotting.

#First, the overall graph with all satellite DNA families in horizontal. 
#You can adjust the color and thickness of the chromosome line in: color="black", linewidth=1 (default parameters).
#You can also adjust the thickness of the annotations in: linewidth=15 (default parameters).
#You can also adjust the position of the legend to legend.position = 'bottom' (default parameters) or remove it (legend.position = 'none')

graphic1 <- ggplot() + 
  geom_segment(data=lengths, aes(x=0, xend=Length, y=Chr, yend=Chr), color="black", linewidth = 1) + 
  geom_segment(data = ordered_data, aes(x = Start, y = Chr, xend = End, yend = Chr, color = Feature), linewidth = 15) + theme_minimal() +
  labs(x="Position", y="Chromosome") + theme(axis.title = element_text(size = 10), axis.text = element_text(size = 10)) + 
  scale_color_manual(name = "SatDNA Family", values = unique(ordered_data$Color), labels = unique(ordered_data$Feature)) + 
  theme(legend.text = element_text(size = 12), legend.position = 'bottom')


#Save the first graphic in PDF

ggsave(filename = "graphic1.pdf", plot = graphic1, width = 20, height = 15)


#Now let's plot the individual graphs in horizontal and combine them into a single PDF.


# Open a PDF file to save the plots

pdf("individual_graphics.pdf", width = 20, height = 15)


# Iterate over each type of annotation making a loop

for (type in type_annotations) {
  # Filter the data by annotation type
  
  data_type <- ordered_data[ordered_data$Feature == type, ]
  
  # Crear el gráfico para el tipo de anotación actual
  
  graphic_type <- ggplot() + 
    geom_segment(data = lengths, aes(x = 0, xend=Length, y = Chr, yend = Chr), color="black", linewidth = 1) + 
    geom_segment(data = data_type, aes(x = Start, y = Chr, xend = End, yend = Chr, color = Color), linewidth = 15) + theme_minimal() + 
    labs(x = "Position", y = "Chromosome") + theme(axis.title = element_text(size = 25), legend.title = element_text(size = 25), axis.text = element_text(size = 25)) + 
    scale_color_manual(name = "SatDNA Family", values = unique(data_type$Color), labels = unique(data_type$Feature)) + 
    theme(legend.text = element_text(size = 20), legend.position = 'bottom')
  
  # Print the plot to the PDF file
  print(graphic_type)
}


# Close the PDF file
dev.off()



########################## USE THE CODE BELOW IF YOU WISH TO PLOT IN VERTICAL ##########################

#Overall graph with all satellite DNA families in vertical. 

graphic1_vertical <- ggplot() + 
  geom_segment(data=lengths, aes(x=Chr, xend=Chr, y=0, yend=Length), color="black", linewidth = 1) + 
  geom_segment(data = ordered_data, aes(x=Chr , y=Start, xend=Chr, yend=End, color = Feature), linewidth = 15) + theme_minimal() +
  labs(x="Position", y="Chromosome") + theme(axis.title = element_text(size = 10), axis.text = element_text(size = 10)) + 
  scale_color_manual(name = "SatDNA Family", values = unique(ordered_data$Color), labels = unique(ordered_data$Feature)) + 
  theme(legend.text = element_text(size = 12), legend.position = 'bottom')

ggsave(filename = "graphic1_vertical.pdf", plot = graphic1_vertical, width = 15, height = 20)


#Individual graphs in vertical and combine them into a single PDF.

# Open a PDF file to save the plots

pdf("individual_graphics_vertical.pdf", width = 20, height = 15)


# Iterate over each type of annotation making a loop

for (type in type_annotations) {
  # Filter the data by annotation type
  
  data_type <- ordered_data[ordered_data$Feature == type, ]
  
  # Crear el gráfico para el tipo de anotación actual
  
  graphic_type_vertical <- ggplot() + 
    geom_segment(data = lengths, aes(x=Chr, xend=Chr, y=0, yend=Length), color="black", linewidth = 1) + 
    geom_segment(data = data_type, aes(x=Chr, y=Start, xend=Chr, yend=End, color = Color), linewidth = 15) + theme_minimal() + 
    labs(x = "Position", y = "Chromosome") + theme(axis.title = element_text(size = 25), legend.title = element_text(size = 25), axis.text = element_text(size = 25)) + 
    scale_color_manual(name = "SatDNA Family", values = unique(data_type$Color), labels = unique(data_type$Feature)) + 
    theme(legend.text = element_text(size = 20), legend.position = 'bottom')
  
  # Print the plot to the PDF file
  print(graphic_type_vertical)
}


# Close the PDF file
dev.off()
