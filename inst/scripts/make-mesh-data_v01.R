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
#grep -v -e "@en ." ./mesh2019.nt > ./mesh2019_others.nt &
#grep -v -e "@en ." ./mesh2020.nt > ./mesh2020_others.nt &
#grep -v -e "@en ." ./mesh2021.nt > ./mesh2021_others.nt &

#Check
#grep -v -e "@[a-z]" ./mesh2019_others.nt > ./mesh2019_others2.nt &
#grep -v -e "@[a-z]" ./mesh2020_others.nt > ./mesh2020_others2.nt &
#grep -v -e "@[a-z]" ./mesh2021_others.nt > ./mesh2021_others2.nt &

#Delete files
#rm -rf mesh2020.nt mesh2019.nt mesh2021_others.nt mesh2020_others.nt mesh2019_others.nt mesh2021.nt

######################################################
#Back to R.
######################################################
#setwd("../")
getwd()
dir()
#system("open ./Mesh")

######################################################
##For Relation
######################################################
File_path <- "./Mesh/mesh2019_others2.nt"

Mesh_PurseNT(File_path)
DFcsv2Rdata(File_path)

######################################################
##For English Labels
######################################################
#rdfs:label
File_path <- "./WikidataRDF-10-Apr-2021/Label_en_rdfs.nt"
PurseNT_Label(File_path)
DFcsv2Rdata(File_path)
#Altlabel
File_path <- "./WikidataRDF-10-Apr-2021/Label_en_Altlabel.nt"
PurseNT_Label(File_path)
DFcsv2Rdata(File_path)
#description
File_path <- "./WikidataRDF-10-Apr-2021/Label_en_description.nt"
PurseNT_Label(File_path)
DFcsv2Rdata(File_path)

######################################################
##For Japanese Labels
######################################################
#rdfs:label
File_path <- "./WikidataRDF-10-Apr-2021/Label_ja_rdfs.nt"
PurseNT_Label(File_path)
DFcsv2Rdata(File_path)
#Altlabel
File_path <- "./WikidataRDF-10-Apr-2021/Label_ja_Altlabel.nt"
PurseNT_Label(File_path)
DFcsv2Rdata(File_path)
#description
File_path <- "./WikidataRDF-10-Apr-2021/Label_ja_description.nt"
PurseNT_Label(File_path)
DFcsv2Rdata(File_path)

#Convert their unicode to Multi-Byte Character (Japanese)


######################################################
#Relation_KEGG_ID.nt
######################################################
File_path <- "./WikidataRDF-10-Apr-2021/Relation_KEGG_ID.nt"
PurseNT_Others(File_path)
DFcsv2Rdata(File_path)
######################################################
#Relation_MeSH_term_ID.nt
######################################################
File_path <- "./WikidataRDF-10-Apr-2021/Relation_MeSH_term_ID.nt"
PurseNT_Others(File_path)
DFcsv2Rdata(File_path)
######################################################
#Relation_MeSH_descriptor_ID.nt
######################################################
File_path <- "./WikidataRDF-10-Apr-2021/Relation_MeSH_descriptor_ID.nt"
PurseNT_Others(File_path)
DFcsv2Rdata(File_path)
######################################################
#Relation_NCBI_taxonomy_ID.nt
######################################################
File_path <- "./WikidataRDF-10-Apr-2021/Relation_NCBI_taxonomy_ID.nt"
PurseNT_Others(File_path)
DFcsv2Rdata(File_path)
######################################################
#Relation_PubChem_CID.nt
######################################################
File_path <- "./WikidataRDF-10-Apr-2021/Relation_PubChem_CID.nt"
PurseNT_Others(File_path)
DFcsv2Rdata(File_path)

######################################################
#PropertyList_at2.nt
#PropertyList_en.nt
#PropertyList_ja.nt
######################################################
File_path <- "./WikidataRDF-10-Apr-2021/PropertyList_at2.nt"
PurseNT_Prop(File_path)
DFcsv2Rdata(File_path)

Dat <- data.frame(readr::read_csv(paste0(sub(".nt", "", File_path), "_df.csv"), col_names = FALSE))

Dat %>%
  head() %>%
  knitr::kable(format = "pipe", booktabs = T, align = "c") %>%
  print()

table(Dat[,2])
table(Dat[,3])


