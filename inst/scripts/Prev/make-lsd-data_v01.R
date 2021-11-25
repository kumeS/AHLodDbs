###################################################################
#Data Dump Downlods: 3th Sep 2019 from LSD Dump
###################################################################
######################################################
## Same processing for all files
######################################################
## No Pre-Processing on MacOSX Terminal
######################################################
#Back to R.
######################################################
#setwd("../")
getwd()
dir()
#system("open ./LSD_RDF/v01_raw")
######################################################
#Load packages
######################################################
library(magrittr)
library(filesstrings)
#??filesstrings
######################################################
##For Relation
######################################################

#lsd_20190903.nt
File_path <- "./LSD_RDF/v01_raw/lsd_20190903.nt"
Mesh_ParseNT(File_path)

filesstrings::file.move(File_path, sub("v01_raw", "v01", File_path))
DFcsv2Rds(File_path, Type="Mesh")

#Mesh2020
File_path <- "./Mesh/mesh2020_others.nt"
Mesh_ParseNT(File_path)
DFcsv2Rds(File_path, Type="Mesh")

#Mesh2021
File_path <- "./Mesh/mesh2021_others.nt"
Mesh_ParseNT(File_path)
DFcsv2Rds(File_path, Type="Mesh")

#Mesh2019 + Mesh2020 + Mesh2021
#system("cat ./Mesh/mesh2019_others_df.csv ./Mesh/mesh2020_others_df.csv ./Mesh/mesh2021_others_df.csv > ./Mesh/mesh219_2020_2021_others_df.csv &")
File_path <- "./Mesh/mesh219_2020_2021_others_df.csv"
DFcsv2Rds(File_path, Type="Mesh")

######################################################
##For English Labels
######################################################
File_path <- "./Mesh/mesh2019_Label_en.nt"
Mesh_ParseNT_Label(File_path)
DFcsv2Rds(File_path,  Type="MeshLabel")

File_path <- "./Mesh/mesh2020_Label_en.nt"
Mesh_ParseNT_Label(File_path)
DFcsv2Rds(File_path,  Type="MeshLabel")

File_path <- "./Mesh/mesh2021_Label_en.nt"
Mesh_ParseNT_Label(File_path)
DFcsv2Rds(File_path,  Type="MeshLabel")

#Mesh2019 + Mesh2020 + Mesh2021
#system("cat ./Mesh/mesh2019_Label_en_df.csv ./Mesh/mesh2020_Label_en_df.csv ./Mesh/mesh2021_Label_en_df.csv > ./Mesh/mesh219_2020_2021_Label_en_df.csv &")
File_path <- "./Mesh/mesh219_2020_2021_Label_en_df.csv"
DFcsv2Rds(File_path, Type="MeshLabel")

######################################################
######################################################
#Pre-Check
#system(paste0("head ", paste0(sub(".nt$", "", File_path), "_df.csv")))
#a <- data.frame(readr::read_csv(paste0(sub(".nt$", "", File_path), "_df.csv"), col_names = F))
#head(a)
#table(grepl("^mesh", a[,1]))
#table(grepl("^mesh", a[,2]))
#table(grepl("^rdf:type", a[,2]))
#table(grepl("^rdfs:label", a[,2]))
#table(grepl("^mesh", a[,3]))
#table(grepl("BLANK", a[,4]))
#table(grepl("@en", a[,4]))



