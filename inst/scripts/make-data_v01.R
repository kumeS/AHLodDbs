###################################################################
#Data Dump Version: 10-Apr-2021 06:31 JST from Wikidata Dump
###################################################################
##Download on MacOSX/LINUX Terminal
#wget https://dumps.wikimedia.org/wikidatawiki/entities/latest-truthy.nt.bz2
##Alternative way: Download from Public_Repository_for_AHwikidataDbs
#source ./gdrive_download.sh
#gdrive_download 1YJbbIHW9ZymAhZCyYEX25IHH8TZIC_bi ./latest-truthy-10-Apr-2021.nt.bz2

##move to the filder
#mkdir WikidataRDF-10-Apr-2021
#mv ./latest-truthy-10-Apr-2021.nt.bz2 ./WikidataRDF-10-Apr-2021

##Decompress the bz2 file
#cd ./WikidataRDF-10-Apr-2021
#bunzip2 -k latest-truthy-10-Apr-2021.nt.bz2
#mv latest-truthy-10-Apr-2021.nt Dump.nt

######################################################
## Same processing for all files
######################################################
## Pre-Processing ##
##extract English labels
#grep -e "@en ." ./Dump.nt > ./Label_en.nt
#grep -e " <http://www.w3.org/2000/01/rdf-schema#label> " ./Label_en.nt > ./Label_en_rdfs.nt
#grep -e " <http://www.w3.org/2004/02/skos/core#altLabel> " ./Label_en.nt > ./Label_en_Altlabel.nt
#grep -e " <http://schema.org/description> " ./Label_en.nt > ./Label_en_description.nt
#rm -rf ./Label_en.nt

##extract Japanese labels
#grep -e "@ja ." ./Dump.nt > ./Label_ja.nt
#grep -e " <http://www.w3.org/2000/01/rdf-schema#label> " ./Label_ja.nt > ./Label_ja_rdfs.nt
#grep -e " <http://www.w3.org/2004/02/skos/core#altLabel> " ./Label_ja.nt > ./Label_ja_Altlabel.nt
#grep -e " <http://schema.org/description> " ./Label_ja.nt > ./Label_ja_description.nt
#rm -rf ./Label_ja.nt

##extract class hierarchy
#grep -e " <http://www.wikidata.org/prop/direct/P279> " ./Dump.nt > ./Relation_P279.nt
#grep -e " <http://www.wikidata.org/prop/direct/P31> " ./Dump.nt > ./Relation_P31.nt
#cat ./Relation_P279.nt ./Relation_P31.nt > ./Relation_P279_P31.nt

#extract property list
#grep -e "^<http://www.wikidata.org/prop/direct/P[0-9]" ./Dump.nt > ./PropertyList.nt

##Others
#grep -v -e '"@[a-z]' ./Dump.nt > ./Relation_i.nt
#grep -v -e " <http://www.wikidata.org/prop/direct/P31> " ./Others_i.nt > ./Others_ii.nt
#grep -v -e " <http://www.wikidata.org/prop/direct/P279> " ./Others_ii.nt > ./Others_iii.nt
#grep -e "^<http://www.wikidata.org/entity/Q[0-9]" ./Others_iii.nt > ./Others_iiii.nt

#MeSH term ID (P6680)
#PubChem CID (P662)
#KEGG ID (P665)
#NCBI taxonomy ID (P685)






