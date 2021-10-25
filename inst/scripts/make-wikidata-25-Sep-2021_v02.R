###################################################################
#Data Dump Version: 25-Sep-2021 09:44 from Wikidata Dump
###################################################################
##Create Directory
if(!dir.exists("Dump")){dir.create("Dump")}

##Download on the Mac OSX Terminal from the original dump
#system("wget -b https://dumps.wikimedia.org/wikidatawiki/entities/latest-truthy.nt.bz2")
#system("mv latest-truthy.nt.bz2 ./Dump/WikidataRDF-25-Sep-2021.nt.bz2")

##Alternative way: Download from Public_Repository_for_AHWikiDataDbs
#source ./gdrive_download.sh
#gdrive_download 1tS3nngpJzsT7-fOb_lrXZWBwwze_xnmV ./Dump/WikidataRDF-25-Sep-2021.nt.bz2

##Decompress the bz2 file
setwd("./Dump")
getwd()

##unzip
#system("bunzip2 -k WikidataRDF-25-Sep-2021.nt.bz2")
##rename
#system("mv WikidataRDF-25-Sep-2021.nt Dump.nt")

######################################################
## Same processing for all files
######################################################
## Pre-Processing on MacOSX Terminal
##extract English labels
#system('grep -e "@en ." ./Dump.nt > ./Label_en.nt')
#system('grep -e " <http://www.w3.org/2000/01/rdf-schema#label> " ./Label_en.nt > ./Label_en_rdfs.nt')
#system('grep -e " <http://www.w3.org/2004/02/skos/core#altLabel> " ./Label_en.nt > ./Label_en_Altlabel.nt')
#system('grep -e " <http://schema.org/description> " ./Label_en.nt > ./Label_en_description.nt')

##extract Japanese labels
#system('grep -e "@ja ." ./Dump.nt > ./Label_ja.nt')
#system('grep -e " <http://www.w3.org/2000/01/rdf-schema#label> " ./Label_ja.nt > ./Label_ja_rdfs.nt')
#system('grep -e " <http://www.w3.org/2004/02/skos/core#altLabel> " ./Label_ja.nt > ./Label_ja_Altlabel.nt')
#system('grep -e " <http://schema.org/description> " ./Label_ja.nt > ./Label_ja_description.nt')

##extract class hierarchy
#system('grep -e " <http://www.wikidata.org/prop/direct/P279> " ./Dump.nt > ./Relation_P279.nt')
#system('grep -e " <http://www.wikidata.org/prop/direct/P31> " ./Dump.nt > ./Relation_P31.nt')
#system('cat ./Relation_P279.nt ./Relation_P31.nt > ./Relation_P279_P31.nt')

##extract property list
#system('grep -e "^<http://www.wikidata.org/prop/direct/P[0-9]" ./Dump.nt > ./PropertyList_01.nt')
#system('grep -e "^<http://www.wikidata.org/entity/P[0-9]" ./Dump.nt > ./PropertyList_02.nt')
#system('cat PropertyList_01.nt PropertyList_02.nt > PropertyList.nt')
#system('rm -rf ./Dump/PropertyList_01.nt ./Dump/PropertyList_02.nt')

######################################################
##Others
######################################################
#system("grep -v -e '\"@[a-z]' ./Dump.nt > ./Others_i.nt")
#system('grep -v -e " <http://www.wikidata.org/prop/direct/P31> " ./Others_i.nt > ./Others_ii.nt')
#system('grep -v -e " <http://www.wikidata.org/prop/direct/P279> " ./Others_ii.nt > ./Others_iii.nt')
#system('grep -e "^<http://www.wikidata.org/entity/Q[0-9]" ./Others_iii.nt > ./Others_iiii.nt')

#MeSH descriptor ID (P486)
#system('grep -e " <http://www.wikidata.org/prop/direct/P486> " ./Others_iiii.nt > ./Relation_MeSH_descriptor_ID.nt')

#PubChem CID (P662)
#system('grep -e " <http://www.wikidata.org/prop/direct/P662> " ./Others_iiii.nt > ./Relation_PubChem_CID.nt')

#KEGG ID (P665)
#system('grep -e " <http://www.wikidata.org/prop/direct/P665> " ./Others_iiii.nt > ./Relation_KEGG_ID.nt')

#NCBI taxonomy ID (P685)
#system('grep -e " <http://www.wikidata.org/prop/direct/P685> " ./Others_iiii.nt > ./Relation_NCBI_taxonomy_ID.nt')

#Remove files
#system('rm -rf ./Dump.nt ./Relation_P279.nt ./Relation_P31.nt ./Others_i.nt ./Others_ii.nt ./Others_iii.nt')
#system('ls -ul -h')

######################################################
#Back to R.
######################################################
setwd("../")
getwd()
dir("./Dump")

#Install
#devtools::install_github( "kumeS/AHLodDbs", force = TRUE)
library(AHLodDbs)
######################################################
##For Relation_P279_P31.nt
######################################################
File_path <- "./Dump/Relation_P279_P31.nt"
Wikidata_PurseNT_ClassHierarchy(File_path)
DFcsv2Rds(File_path, Type="wikidata")
file.remove(c("./Dump/Relation_P279_P31_df.csv"))

if(F){
#Check Data
Dat <- readRDS("./Dump/Relation_P279_P31_df.Rds")

head(Dat)
table(grepl("^wd:Q", Dat$Subject))
table(grepl("^wdt:P", Dat$Property))
table(Dat$Property)
table(grepl("^wd:Q", Dat$Object))
}

######################################################
##For English Labels
######################################################
#rdfs:label
File_path <- "./Dump/Label_en_rdfs.nt"
Wikidata_PurseNT_Label(File_path)
DFcsv2Rds(File_path, Type="wikilabel")

#Altlabel
File_path <- "./Dump/Label_en_Altlabel.nt"
Wikidata_PurseNT_Label(File_path)
DFcsv2Rds(File_path, Type="wikilabel")

#description
File_path <- "./Dump/Label_en_description.nt"
Wikidata_PurseNT_Label(File_path)
DFcsv2Rds(File_path, Type="wikilabel")


######################################################
##For Japanese Labels
######################################################
##############################
#rdfs:label
##############################
File_path <- "./Dump/Label_ja_rdfs.nt"
Wikidata_PurseNT_Label(File_path)

#Convert their unicode (Escape character) to Multi-Byte Character (Japanese)
system(paste0("cat ", sub(".nt$", "_df.csv", File_path), " | sed 's/\\\\u\\(....\\)/\\&#x\\1;/g' | nkf --numchar-input -w > ", sub(".nt$", "_df_nkf.csv", File_path)))
Proc_af_nkf(File_path=sub(".nt$", "_df_nkf.csv", File_path))
file.remove(c("./Dump/Label_ja_rdfs_df_nkf.csv", "./Dump/Label_ja_rdfs_df.csv"))

if(F){
#Check Data
Dat <- readRDS("./Dump/Label_ja_rdfs_df.Rds")

head(Dat)
table(grepl("^wd:Q", Dat$Subject))
table(Dat$Property)
table(grepl("^wd:Q", Dat$Object))
table(Dat$OtherInfo)
}

##############################
#Altlabel
##############################
File_path <- "./Dump/Label_ja_Altlabel.nt"
Wikidata_PurseNT_Label(File_path)

#Convert their unicode (Escape character) to Multi-Byte Character (Japanese)
system(paste0("cat ", sub(".nt$", "_df.csv", File_path), " | sed 's/\\\\u\\(....\\)/\\&#x\\1;/g' | nkf --numchar-input -w > ", sub(".nt$", "_df_nkf.csv", File_path)))
Proc_af_nkf(File_path=sub(".nt$", "_df_nkf.csv", File_path))
file.remove(c("./Dump/Label_ja_Altlabel_df.csv", "./Dump/Label_ja_Altlabel_df_nkf.csv"))

######################################################
#Relation_KEGG_ID.nt
######################################################
File_path <- "./Dump/Relation_KEGG_ID.nt"
Wikidata_PurseNT_Others(File_path)
DFcsv2Rds(File_path)
######################################################
#Relation_MeSH_term_ID.nt
######################################################
File_path <- "./Dump/Relation_MeSH_term_ID.nt"
Wikidata_PurseNT_Others(File_path)
DFcsv2Rds(File_path)
######################################################
#Relation_MeSH_descriptor_ID.nt
######################################################
File_path <- "./Dump/Relation_MeSH_descriptor_ID.nt"
Wikidata_PurseNT_Others(File_path)
DFcsv2Rds(File_path)
######################################################
#Relation_NCBI_taxonomy_ID.nt
######################################################
File_path <- "./Dump/Relation_NCBI_taxonomy_ID.nt"
Wikidata_PurseNT_Others(File_path)
DFcsv2Rds(File_path)
######################################################
#Relation_PubChem_CID.nt
######################################################
File_path <- "./Dump/Relation_PubChem_CID.nt"
Wikidata_PurseNT_Others(File_path)
DFcsv2Rds(File_path)

