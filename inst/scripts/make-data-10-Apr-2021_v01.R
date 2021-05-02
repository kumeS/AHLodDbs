###################################################################
#Data Dump Version: 10-Apr-2021 06:31 JST from Wikidata Dump
###################################################################
##Download on MacOSX/LINUX Terminal
#wget https://dumps.wikimedia.org/wikidatawiki/entities/latest-truthy.nt.bz2
##Alternative way: Download from Public_Repository_for_AHWikiDataDbs
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
## Pre-Processing on MacOSX Terminal
##extract English labels
#grep -e "@en ." ./Dump.nt > ./Label_en.nt
#grep -e " <http://www.w3.org/2000/01/rdf-schema#label> " ./Label_en.nt > ./Label_en_rdfs.nt
#grep -e " <http://www.w3.org/2004/02/skos/core#altLabel> " ./Label_en.nt > ./Label_en_Altlabel.nt
#grep -e " <http://schema.org/description> " ./Label_en.nt > ./Label_en_description.nt

##extract Japanese labels
#grep -e "@ja ." ./Dump.nt > ./Label_ja.nt
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
#grep -e " <http://wikiba.se/ontology#directClaim> " ./Dump.nt > ./PropertyList_directClaim.nt
#cat PropertyList_01.nt PropertyList_02.nt PropertyList_directClaim.nt > PropertyList.nt

##Others
#grep -v -e '"@[a-z]' ./Dump.nt > ./Others_i.nt
#grep -v -e " <http://www.wikidata.org/prop/direct/P31> " ./Others_i.nt > ./Others_ii.nt
#grep -v -e " <http://www.wikidata.org/prop/direct/P279> " ./Others_ii.nt > ./Others_iii.nt
#grep -e "^<http://www.wikidata.org/entity/Q[0-9]" ./Others_iii.nt > ./Others_iiii.nt

#MeSH term ID (P6680)
#grep -e " <http://www.wikidata.org/prop/direct/P6680> " ./Others_iiii.nt > ./Relation_MeSH_term_ID.nt

#PubChem CID (P662)
#grep -e " <http://www.wikidata.org/prop/direct/P662> " ./Others_iiii.nt > ./Relation_PubChem_CID.nt

#KEGG ID (P665)
#grep -e " <http://www.wikidata.org/prop/direct/P665> " ./Others_iiii.nt > ./Relation_KEGG_ID.nt

#NCBI taxonomy ID (P685)
#grep -e " <http://www.wikidata.org/prop/direct/P685> " ./Others_iiii.nt > ./Relation_NCBI_taxonomy_ID.nt

#Remove files
#rm -rf ./Dump.nt ./Relation_P279.nt ./Relation_P31.nt ./PropertyList_01.nt ./PropertyList_02.nt ./PropertyList_directClaim.nt ./Others_i.nt ./Others_ii.nt ./Others_iii.nt

#Chnage Dir.
setwd("./WikidataRDF-10-Apr-2021/")
dir()

######################################################
##For Relation_P279_P31.nt
######################################################
#system("open ../WikidataRDF-10-Apr-2021")
File_path <- "./Relation_P279_P31.nt"
con_file <- file(description = File_path, open = "r")
con_file
#close(con_file)

#Execution number
x <- 0
#Rows per read
N <- 100000

#Purse NT file to CSV
while( TRUE ){
x <- x + 1
print(paste0("No: ", x, " Line: ", x*N ))
try(a <- readLines(con_file, n = N), silent=T)
if ( length(a) == 0 ) { close(con_file); break }
#head(a)

#AiBiCiDiEiFiG: Unique arbitrary string
a1 <- unlist(strsplit(sub(" ", "AiBiCiDiEiFiG", sub(" ", "AiBiCiDiEiFiG", a)), split="AiBiCiDiEiFiG"))
if( (length(a1) %% 3) == 0 ){
  b <- matrix(a1, ncol=3, byrow=T)
}else{
  b <- matrix(a1[1:(length(a1) - (length(a1) %% 3))], ncol=3, byrow=T)
}

#head(b)
# remove [.]
b[,3] <- sub(" [.]$", "", b[,3])

#Subject
cc <- grepl("^<http://www.wikidata.org/entity/Q[0-9]", b[,1])
b[cc,1] <- sub("^<http://www.wikidata.org/entity/", "wd:", b[cc,1])
b[cc,1] <- sub(">$", "", b[cc,1])
b <- b[grepl("^wd:Q", b[,1]),]

#Property
cc <- grepl("^<http://www.wikidata.org/prop/direct/P[0-9]", b[,2])
b[cc,2] <- sub("^<http://www.wikidata.org/prop/direct/", "wdt:", b[cc,2])
b[cc,2] <- sub(">$", "", b[cc,2])
b <- b[grepl("^wdt:P", b[,2]),]

#Object
cc <- grepl("^<http://www.wikidata.org/entity/Q[0-9]", b[,3])
b[cc,3] <- sub("^<http://www.wikidata.org/entity/", "wd:", b[cc,3])
b[cc,3] <- sub(">$", "", b[cc,3])
b <- b[grepl("^wd:Q", b[,3]),]

#head(b)
#dim(b)

#convert matrix to DF
d <- data.frame(b)

if(x == 1){
readr::write_csv(d,
                 file=paste0(sub(".nt", "", File_path), "_df.csv"),
                 append=FALSE, col_names = FALSE)
}else{
readr::write_csv(d,
                 file=paste0(sub(".nt", "", File_path), "_df.csv"),
                 append=TRUE, col_names = FALSE)
}}
#close(con_file)

#Check the data
Dat <- data.frame(readr::read_csv(paste0(sub(".nt", "", File_path), "_df.csv")))


saveRDS(Dat, file = paste0(sub(".nt", "", File_path), "_df.Rdata"))








