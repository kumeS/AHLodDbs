###################################################################
#Data Dump Downlods: 28-May-2021 from Mesh Dump
###################################################################
######################################################
## Same processing for all files
######################################################
## Pre-Processing on MacOSX Terminal
##extract English labels
#grep -e "@en ." ./mesh2019.nt > ./mesh2019_Label_en.nt &
#grep -e "@en ." ./mesh2020.nt > ./mesh2020_Label_en.nt &
#grep -e "@en ." ./mesh2021.nt > ./mesh2021_Label_en.nt &

##extract others
#grep -v -e "@en ." ./mesh2019.nt > ./mesh2019_others0.nt &
#grep -v -e "@en ." ./mesh2020.nt > ./mesh2020_others0.nt &
#grep -v -e "@en ." ./mesh2021.nt > ./mesh2021_others0.nt &

#Check
#grep -v -e "@[a-z]" ./mesh2019_others0.nt > ./mesh2019_others.nt &
#grep -v -e "@[a-z]" ./mesh2020_others0.nt > ./mesh2020_others.nt &
#grep -v -e "@[a-z]" ./mesh2021_others0.nt > ./mesh2021_others.nt &

#Delete files
#rm -rf mesh2021.nt mesh2020.nt mesh2019.nt mesh2021_others0.nt mesh2020_others0.nt mesh2019_others0.nt

######################################################
#Back to R.
######################################################
#rm(list=ls())
setwd("./AHLodDbs_02_Dataset_v01/MeSH_RDF/v01")
getwd()
dir()
######################################################
#Load packages
######################################################
library(magrittr)
######################################################
##For Relation
######################################################

#Mesh2021
File_path <- "./mesh2021_others.nt"
PurseNT(File_path)
DFcsv2Rds(File_path, Type="Mesh")

######################################################
##For English Labels
######################################################
File_path <- "./Mesh/mesh2019_Label_en.nt"
Mesh_PurseNT_Label(File_path)
DFcsv2Rds(File_path,  Type="MeshLabel")

File_path <- "./Mesh/mesh2020_Label_en.nt"
Mesh_PurseNT_Label(File_path)
DFcsv2Rds(File_path,  Type="MeshLabel")

File_path <- "./Mesh/mesh2021_Label_en.nt"
Mesh_PurseNT_Label(File_path)
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


