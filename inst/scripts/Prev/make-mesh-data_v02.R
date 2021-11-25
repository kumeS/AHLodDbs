###################################################################
#Data Dump Downlods: 28-May-2021 from Mesh Dump
#On R.
###################################################################
setwd("./AHLodDbs_02_Dataset_v01/MeSH_RDF/v01")
getwd(); dir()

###################################################################
## Same processing for all files
###################################################################
#unzip
system("gzip -d -k mesh2021.nt.gz &")

##extract English labels
system('grep -e "@en ." ./mesh2021.nt > ./mesh2021_Label_en.nt &')

##extract others
system('grep -v -e "@en ." ./mesh2021.nt > ./mesh2021_others0.nt &')

#Check
system('grep -v -e "@[a-z]" ./mesh2021_others0.nt > ./mesh2021_others.nt &')

#Delete files
system('rm -rf mesh2021.nt mesh2021_others0.nt &')

rm(list=ls())
###################################################################
#Load packages
###################################################################
#ProxySet(Locations = "OECU")
#devtools::install_github("kumeS/AHLodDbs", force = TRUE)
library(AHLodDbs)
library(magrittr)

###################################################################
##For English Labels
###################################################################
File_path <- "./mesh2021_Label_en.nt"
ParseNT_Label(File_path)
DFcsv2Rds(File_path,  Type="MeshLabel")

###################################################################
##For Relation
###################################################################
#Mesh2021
File_path <- "./mesh2021_others.nt"
ParseNT(File_path)
DFcsv2Rds(File_path, Type="Mesh")

###################################################################
#Create the label dataset
###################################################################
rm(list=ls())
MeshLabel <- readRDS("./mesh2021_Label_en_df.Rds")

head(MeshLabel); dim(MeshLabel)
length(unique(MeshLabel$Subject))
length(unique(MeshLabel$Property))
length(unique(MeshLabel$Object))
length(unique(MeshLabel$OtherInfo))
MeshLabel$SubInfo <- "BLANK"

#Subject 01
cc <- grepl("^mesh:[A-Z][0-9][0-9][0-9]", MeshLabel$Subject)
table(MeshLabel$SubInfo[cc])
MeshLabel$SubInfo[cc] <- paste0("IDs:", stringr::str_sub(MeshLabel$Subject[cc], start=1, end=6))

#Subject 02
cc <- !grepl("^mesh:[A-Z][0-9][0-9][0-9]", MeshLabel$Subject)
table(MeshLabel$SubInfo[cc])
MeshLabel$SubInfo[cc] <- paste0("Tree:", stringr::str_sub(MeshLabel$Subject[cc], start=1, end=6))
table(MeshLabel$SubInfo)
table(MeshLabel$Property)

###################################################################
###################################################################
Prop <- c("rdfs:label",
          "meshv:altLabel",
          "meshv:prefLabel")

MeshLabel00 <- MeshLabel[MeshLabel$Property %in% Prop,]
#table(MeshLabel00$SubInfo)
#table(MeshLabel00$Property)
#head(MeshLabel00[MeshLabel00$SubInfo == "IDs:mesh:D",])
#head(MeshLabel00[MeshLabel00$SubInfo == "Tree:mesh:D",])

MeshLabel01 <- MeshLabel00[!grepl("^Tree", MeshLabel00$SubInfo),]
#table(MeshLabel01$SubInfo)
#table(MeshLabel01$Property)
#head(MeshLabel01[MeshLabel01$SubInfo == "IDs:mesh:D",])
#head(MeshLabel01[MeshLabel01$SubInfo == "Tree:mesh:D",])

#Save
saveRDS(MeshLabel01, "./mesh2021_Label_en_dfR.Rds")

###################################################################
#Create the class-hierarchy-related dataset
###################################################################
rm(list=ls())
Mesh <- readRDS("./mesh2021_others_df.Rds")
head(Mesh); dim(Mesh)
table(Mesh$Property)

Mesh$SubInfo <- "BLANK"
Mesh$ObjInfo <- "BLANK"
head(Mesh)

#Subject 01
cc <- grepl("^mesh:[A-Z][0-9][0-9][0-9]", Mesh$Subject)
table(Mesh$SubInfo[cc])
Mesh$SubInfo[cc] <- paste0("IDs:", stringr::str_sub(Mesh$Subject[cc], start=1, end=6))

#Subject 02
cc <- !grepl("^mesh:[A-Z][0-9][0-9][0-9]", Mesh$Subject)
table(Mesh$SubInfo[cc])
Mesh$SubInfo[cc] <- paste0("Tree:", stringr::str_sub(Mesh$Subject[cc], start=1, end=6))
table(Mesh$SubInfo)

#Tree
cc <- grepl("tree|Tree", Mesh$Property)
table(cc)
table(Mesh$OtherInfo[cc])
Mesh$OtherInfo[cc] <- "Tree"
Mesh$ObjInfo[cc] <- paste0("Tree:", stringr::str_sub(Mesh$Object[cc], start=1, end=6))
head(Mesh[cc,])

cc1 <- grepl("rdf:type", Mesh$Property)
cc2 <- grepl("tree|Tree", Mesh$Object)
cc3 <- apply(data.frame(cc1, cc2), 1, all)
table(Mesh$OtherInfo[cc3])
Mesh$OtherInfo[cc3] <- "Tree"
Mesh$ObjInfo[cc3] <- "Tree"

#Descriptor
cc <- grepl("^mesh:[A-Z][0-9][0-9][0-9]", Mesh$Object)
Mesh$OtherInfo[cc] <- "IDs"
Mesh$ObjInfo[cc] <- paste0("IDs:", stringr::str_sub(Mesh$Object[cc], start=1, end=6))
#head(Mesh[cc,])

cc <- grepl("^[A-Z][0-9][0-9][0-9][0-9]", Mesh$Object)
Mesh$OtherInfo[cc] <- "identifier"
Mesh$ObjInfo[cc] <- paste0("identifier:", stringr::str_sub(Mesh$Object[cc], start=1, end=1))
#head(Mesh[cc,])

head(Mesh)
Mesh[is.na(Mesh$OtherInfo),]
Mesh[is.na(Mesh$OtherInfo),"OtherInfo"] <- "BLANK"

table(Mesh$SubInfo)
table(Mesh$ObjInfo)

table(Mesh$SubInfo == "BLANK")
table(Mesh$ObjInfo == "BLANK")
#BLANK 6722756

###################################################################
###################################################################
List <- c("meshv:broaderConcept", "meshv:broaderDescriptor",
          "meshv:concept", "meshv:Concept", "meshv:narrowerConcept",
          "meshv:preferredConcept")

#Paticular property
Mesh00 <- Mesh[Mesh$Property %in% List,]
head(Mesh00)
rownames(Mesh00) <- 1:nrow(Mesh00)
Mesh01 <- Mesh00

##
Mesh00.prefConcept <- Mesh00[Mesh00$Property == "meshv:preferredConcept",]
rownames(Mesh00.prefConcept) <- 1:nrow(Mesh00.prefConcept)

head(Mesh00.prefConcept)
dim(Mesh00.prefConcept)
length(unique(Mesh00.prefConcept$Subject))
length(unique(Mesh00.prefConcept$Object))

#M2DC
for(n in 1:nrow(Mesh00.prefConcept)){
#n <- 1
#message(n)
head(Mesh00.prefConcept)
head(Mesh01)
Mesh01$Subject[Mesh01$Subject == Mesh00.prefConcept$Object[n]] <- Mesh00.prefConcept$Subject[n]
Mesh01$Object[Mesh01$Object == Mesh00.prefConcept$Object[n]] <- Mesh00.prefConcept$Subject[n]
}

#Save









