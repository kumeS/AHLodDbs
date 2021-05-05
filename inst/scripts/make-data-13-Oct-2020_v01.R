###################################################################
#Data Dump Version: 13-Oct-2020 from Wikidata Dump
###################################################################
##Download from Public_Repository_for_AHWikiDataDbs
#source ./gdrive_download.sh
#gdrive_download 1RVV8_NbDh7PTTFAPl1Z_p_n3cWoGyaIF ./latest-truthy-13-Oct-2020.nt.gz

##move to the filder
#mkdir WikidataRDF-13-Oct-2020
#mv ./latest-truthy-13-Oct-2020.nt.gz ./WikidataRDF-13-Oct-2020

##Decompress the bz2 file
#cd ./WikidataRDF-13-Oct-2020
#gunzip -k latest-truthy-13-Oct-2020.nt.gz
#mv latest-truthy-13-Oct-2020.nt Dump.nt

######################################################
## Same processing for all files
######################################################
## Pre-Processing on MacOSX Terminal
##extract English labels
#grep -e '"@en .' ./Dump.nt > ./Label_en.nt
#grep -e " <http://www.w3.org/2000/01/rdf-schema#label> " ./Label_en.nt > ./Label_en_rdfs.nt
#grep -e " <http://www.w3.org/2004/02/skos/core#altLabel> " ./Label_en.nt > ./Label_en_Altlabel.nt
#grep -e " <http://schema.org/description> " ./Label_en.nt > ./Label_en_description.nt

##extract Japanese labels
#grep -e '"@ja .' ./Dump.nt > ./Label_ja.nt
#grep -e " <http://www.w3.org/2000/01/rdf-schema#label> " ./Label_ja.nt > ./Label_ja_rdfs.nt
#grep -e " <http://www.w3.org/2004/02/skos/core#altLabel> " ./Label_ja.nt > ./Label_ja_Altlabel.nt
#grep -e " <http://schema.org/description> " ./Label_ja.nt > ./Label_ja_description.nt

##extract class hierarchy
#grep -e " <http://www.wikidata.org/prop/direct/P279> " ./Dump.nt > ./Relation_P279.nt
#grep -e " <http://www.wikidata.org/prop/direct/P31> " ./Dump.nt > ./Relation_P31.nt
#cat ./Relation_P279.nt ./Relation_P31.nt > ./Relation_P279_P31.nt

##extract property list
#grep -e "^<http://www.wikidata.org/prop/direct/P[0-9]" ./Dump.nt > ./PropertyList_01.nt
#grep -e "^<http://www.wikidata.org/entity/P[0-9]" ./Dump.nt > ./PropertyList_02.nt
#cat PropertyList_01.nt PropertyList_02.nt > PropertyList.nt
#grep -v -e '"@[a-z]' ./PropertyList.nt > ./PropertyList_woat.nt
#grep -e "> .$" ./PropertyList_woat.nt > ./PropertyList_woat2.nt
#grep -e '"@en .' ./PropertyList.nt > ./PropertyList_en.nt
#grep -e '"@ja .' ./PropertyList.nt > ./PropertyList_ja.nt

##Others
#grep -v -e '"@[a-z]' ./Dump.nt > ./Others_i.nt
#grep -v -e " <http://www.wikidata.org/prop/direct/P31> " ./Others_i.nt > ./Others_ii.nt
#grep -v -e " <http://www.wikidata.org/prop/direct/P279> " ./Others_ii.nt > ./Others_iii.nt
#grep -e "^<http://www.wikidata.org/entity/Q[0-9]" ./Others_iii.nt > ./Others_iiii.nt

#MeSH term ID (P6680)
#grep -e " <http://www.wikidata.org/prop/direct/P6680> " ./Others_iiii.nt > ./Relation_MeSH_term_ID.nt

#MeSH descriptor ID (P486)
#grep -e " <http://www.wikidata.org/prop/direct/P486> " ./Others_iiii.nt > ./Relation_MeSH_descriptor_ID.nt

#PubChem CID (P662)
#grep -e " <http://www.wikidata.org/prop/direct/P662> " ./Others_iiii.nt > ./Relation_PubChem_CID.nt

#KEGG ID (P665)
#grep -e " <http://www.wikidata.org/prop/direct/P665> " ./Others_iiii.nt > ./Relation_KEGG_ID.nt

#NCBI taxonomy ID (P685)
#grep -e " <http://www.wikidata.org/prop/direct/P685> " ./Others_iiii.nt > ./Relation_NCBI_taxonomy_ID.nt

#Remove files
#rm -rf ./Dump.nt ./Relation_P279.nt ./Relation_P31.nt ./Others_i.nt ./Others_ii.nt ./Others_iii.nt

#ls -ul -h

#Chnage Dir.
setwd("./WikidataRDF-13-Oct-2020/")
dir()

######################################################
##For Relation_P279_P31.nt
######################################################
#system("open ../WikidataRDF-13-Oct-2020")
#source("../AHWikiDataDbs/inst/scripts/make-data_v02.R")
File_path <- "./Relation_P279_P31.nt"

#Run
PurseNT_ClassHierarchy(File_path)
#close(con_file)

#Check the data
Dat <- data.frame(readr::read_csv(paste0(sub(".nt", "", File_path), "_df.csv"), col_names = FALSE))
head(Dat)
dim(Dat)
sum(grepl("^wd:", Dat[,1]))
sum(grepl("^wdt:", Dat[,2]))
sum(grepl("^wd:", Dat[,3]))
system.time(saveRDS(Dat, file = paste0(sub(".nt", "", File_path), "_df.Rdata")))
#Time: 102.385 sec
#rm(list=ls())

system.time(data.frame(readr::read_csv(paste0(sub(".nt", "", File_path), "_df.csv"), col_names = FALSE)))
#Time: 72.664 sec
system.time(readRDS(file = paste0(sub(".nt", "", File_path), "_df.Rdata")))
#Time: 90.694 sec


######################################################
##For Label_en_rdfs.nt
######################################################
#system("open ../WikidataRDF-13-Oct-2020")
#source("../AHWikiDataDbs/inst/scripts/make-data_v02.R")
File_path <- "./Label_en_rdfs.nt"
#Run
PurseNT_Label(File_path)
#close(con_file)
DFcsv2Rdata(File_path)

######################################################
#Relation_KEGG_ID.nt
######################################################
File_path <- "./Relation_KEGG_ID.nt"
PurseNT_Others(File_path)
DFcsv2Rdata(File_path)
######################################################
#Relation_MeSH_term_ID.nt
######################################################
File_path <- "./Relation_MeSH_term_ID.nt"
PurseNT_Others(File_path)
DFcsv2Rdata(File_path)
######################################################
#Relation_MeSH_descriptor_ID.nt
######################################################
File_path <- "./Relation_MeSH_descriptor_ID.nt"
PurseNT_Others(File_path)
DFcsv2Rdata(File_path)
######################################################
#Relation_NCBI_taxonomy_ID.nt
######################################################
File_path <- "./Relation_NCBI_taxonomy_ID.nt"
PurseNT_Others(File_path)
DFcsv2Rdata(File_path)
######################################################
#Relation_PubChem_CID.nt
######################################################
File_path <- "./Relation_PubChem_CID.nt"
PurseNT_Others(File_path)
DFcsv2Rdata(File_path)

######################################################
#PropertyList_at2.nt
#PropertyList_en.nt
#PropertyList_ja.nt
######################################################
File_path <- "./PropertyList_at2.nt"
PurseNT_Prop(File_path)
DFcsv2Rdata(File_path)

Dat <- data.frame(readr::read_csv(paste0(sub(".nt", "", File_path), "_df.csv"), col_names = FALSE))

Dat %>%
  head() %>%
  knitr::kable(format = "pipe", booktabs = T, align = "c") %>%
  print()

table(Dat[,2])
table(Dat[,3])


