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

#MeSH descriptor ID (P486)
#grep -e " <http://www.wikidata.org/prop/direct/P486> " ./Others_iiii.nt > ./Relation_MeSH_descriptor_ID.nt

#PubChem CID (P662)
#grep -e " <http://www.wikidata.org/prop/direct/P662> " ./Others_iiii.nt > ./Relation_PubChem_CID.nt

#KEGG ID (P665)
#grep -e " <http://www.wikidata.org/prop/direct/P665> " ./Others_iiii.nt > ./Relation_KEGG_ID.nt

#NCBI taxonomy ID (P685)
#grep -e " <http://www.wikidata.org/prop/direct/P685> " ./Others_iiii.nt > ./Relation_NCBI_taxonomy_ID.nt

#Remove files
#rm -rf ./Label_en.nt ./Label_ja.nt ./PropertyList_01.nt ./PropertyList_02.nt ./PropertyList_woat.nt ./PropertyList.nt
#rm -rf ./Dump.nt ./Relation_P279.nt ./Relation_P31.nt ./Others_i.nt ./Others_ii.nt ./Others_iii.nt

#ls -ul -h

######################################################
#Back to R.
######################################################
#setwd("../")
getwd()
dir()
#system("open ./WikidataRDF-13-Oct-2020")

######################################################
##For Relation_P279_P31.nt
######################################################
File_path <- "./WikidataRDF-13-Oct-2020/Relation_P279_P31.nt"
Wikidata_ParseNT_ClassHierarchy(File_path)
DFcsv2Rds(File_path)

#check
if(F){
a <- readRDS("./WikidataRDF-13-Oct-2020/v01/Relation_P279_P31_df.Rds")
head(a, n=100)
table(grepl("wd:", a$X1))
table(grepl("wdt:", a$X2))
table(grepl("wd:", a$X3))

}

######################################################
#Relation_KEGG_ID.nt
######################################################
File_path <- "./WikidataRDF-13-Oct-2020/Relation_KEGG_ID.nt"
Wikidata_ParseNT_Others(File_path)
DFcsv2Rds(File_path, Type="Wikidata")
######################################################
#Relation_MeSH_descriptor_ID.nt
######################################################
File_path <- "./WikidataRDF-13-Oct-2020/Relation_MeSH_descriptor_ID.nt"
Wikidata_ParseNT_Others(File_path)
DFcsv2Rds(File_path, Type="Wikidata")
######################################################
#Relation_NCBI_taxonomy_ID.nt
######################################################
File_path <- "./WikidataRDF-13-Oct-2020/Relation_NCBI_taxonomy_ID.nt"
Wikidata_ParseNT_Others(File_path)
DFcsv2Rds(File_path, Type="ID")
######################################################
#Relation_PubChem_CID.nt
######################################################
File_path <- "./WikidataRDF-13-Oct-2020/Relation_PubChem_CID.nt"
Wikidata_ParseNT_Others(File_path)
DFcsv2Rds(File_path, Type="ID")
######################################################
#PropertyList_at2.nt
#PropertyList_en.nt
#PropertyList_ja.nt
######################################################
File_path <- "./WikidataRDF-13-Oct-2020/PropertyList_at2.nt"
ParseNT_Prop(File_path)
DFcsv2Rds(File_path)

Dat <- data.frame(readr::read_csv(paste0(sub(".nt", "", File_path), "_df.csv"), col_names = FALSE))

Dat %>%
  head() %>%
  knitr::kable(format = "pipe", booktabs = T, align = "c") %>%
  print()

table(Dat[,2])
table(Dat[,3])

######################################################
##For English Labels
######################################################
#rdfs:label
File_path <- "./WikidataRDF-13-Oct-2020/Label_en_rdfs.nt"
Wikidata_ParseNT_Label(File_path)
DFcsv2Rds(File_path)

#Altlabel
File_path <- "./WikidataRDF-13-Oct-2020/Label_en_Altlabel.nt"
Wikidata_ParseNT_Label(File_path)
DFcsv2Rds(File_path)

#description
File_path <- "./WikidataRDF-13-Oct-2020/Label_en_description.nt"
Wikidata_ParseNT_Label(File_path)
DFcsv2Rds(File_path)



######################################################
##For Japanese Labels
######################################################
#rdfs:label
File_path <- "./WikidataRDF-13-Oct-2020/Label_ja_rdfs.nt"
Wikidata_ParseNT_Label(File_path)
DFcsv2Rds(File_path)

#Convert their unicode (Escape character) to Multi-Byte Character (Japanese)
system(paste0("cat ", sub(".nt$", ".csv", File_path), " | sed 's/\\\u\(....\)/\&#x\1;/g' | nkf --numchar-input -w > ", sub(".nt$", "_nkf.csv", File_path)))

#Altlabel
File_path <- "./WikidataRDF-13-Oct-2020/Label_ja_Altlabel.nt"
Wikidata_ParseNT_Label(File_path)
DFcsv2Rds(File_path)

#description
File_path <- "./WikidataRDF-13-Oct-2020/Label_ja_description.nt"
Wikidata_ParseNT_Label(File_path)
DFcsv2Rds(File_path)


