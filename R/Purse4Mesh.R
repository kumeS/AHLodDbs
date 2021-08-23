##' @title Purse Mesh data to a new class hierarchy
##'
##' @param File_path a character vector for a N-triple (NT) file (.nt).
##' @param Labels a logical
##'
##' @description This function convert to a new class hierarchy.
##'
##' @author Satoshi Kume
##' @export Purse4Mesh
##' @importFrom magrittr %>%
##'
##' @examples \dontrun{
##'
##' #Run
##' File_path <- "./Label_en_rdfs.nt"
##' Purse4Mesh(File_path)
##'
##' }
##'

Purse4Mesh <- function(File_path, Labels=FALSE){

if(any(dir() == sub("^./", "", paste0(sub(".nt$", "", File_path), "_df.Rds")))){
File_path00 <- paste0(sub(".nt$", "", File_path), "_df.Rds")
message(paste0("Read data"))
Dat <- readRDS(File_path00)
}else{
return(message("Warning: No proper value of File_path"))
}

if(Labels){
# Parse Mesh RDF to data.frame
if(F){
MeshLabel_2021df <- readRDS("./00_Mesh_Input/mesh2021_Label_en_df.Rds")

head(MeshLabel_2021df)
dim(MeshLabel_2021df)
length(unique(MeshLabel_2021df$Subject))
length(unique(MeshLabel_2021df$Property))
length(unique(MeshLabel_2021df$Object))
length(unique(MeshLabel_2021df$OtherInfo))
MeshLabel_2021df$SubInfo <- "BLANK"

#Subject 01
cc <- grepl("^mesh:[A-Z][0-9][0-9][0-9]", MeshLabel_2021df$Subject)
table(MeshLabel_2021df$SubInfo[cc])
MeshLabel_2021df$SubInfo[cc] <- paste0("IDs:", stringr::str_sub(MeshLabel_2021df$Subject[cc], start=1, end=6))

#Subject 02
cc <- !grepl("^mesh:[A-Z][0-9][0-9][0-9]", MeshLabel_2021df$Subject)
table(MeshLabel_2021df$SubInfo[cc])
MeshLabel_2021df$SubInfo[cc] <- paste0("Tree:", stringr::str_sub(MeshLabel_2021df$Subject[cc], start=1, end=6))
table(MeshLabel_2021df$SubInfo)

saveRDS(MeshLabel_2021df, "./00_Mesh_Input/mesh2021_Label_en_df_R.Rds")

head(MeshLabel_2021df)
MeshLabel_2021dfR <- MeshLabel_2021df[MeshLabel_2021df$Property == "rdfs:label",]
table(MeshLabel_2021dfR$SubInfo)
saveRDS(MeshLabel_2021dfR, "./00_Mesh_Input/mesh2021_Label_en_df_RR.Rds")
#table(grepl("mesh[:]", MeshLabel_2021df$Object))
}
}

if(!Labels){
#mesh2021_others_df.Rds
#head(Dat)
#table(grepl("mesh[:]", Dat$Subject))
Dat$SubInfo <- "BLANK"
Dat$ObjInfo <- "BLANK"
#head(Dat)

#Subject 01
cc <- grepl("^mesh:[A-Z][0-9][0-9][0-9]", Dat$Subject)
#table(Dat$SubInfo[cc])
Dat$SubInfo[cc] <- paste0("IDs:", stringr::str_sub(Dat$Subject[cc], start=1, end=6))

#Subject 02
cc <- !grepl("^mesh:[A-Z][0-9][0-9][0-9]", Dat$Subject)
#table(Dat$SubInfo[cc])
Dat$SubInfo[cc] <- paste0("Tree:", stringr::str_sub(Dat$Subject[cc], start=1, end=6))

#Tree
#head(Dat)
cc <- grepl("tree|Tree", Dat$Property)
#head(Dat[cc,])
Dat$OtherInfo[cc] <- "Tree"
Dat$ObjInfo[cc] <- paste0("Tree:", stringr::str_sub(Dat$Object[cc], start=1, end=6))

cc1 <- grepl("rdf:type", Dat$Property)
cc2 <- grepl("tree|Tree", Dat$Object)
cc3 <- apply(data.frame(cc1, cc2), 1, all)
Dat$OtherInfo[cc3] <- "Tree"
Dat$ObjInfo[cc3] <- "Tree"
#head(Dat[cc3,])

#Descriptor
cc <- grepl("^mesh:[A-Z][0-9][0-9][0-9]", Dat$Object)
Dat$OtherInfo[cc] <- "IDs"
Dat$ObjInfo[cc] <- paste0("IDs:", stringr::str_sub(Dat$Object[cc], start=1, end=6))
#head(Dat[cc,])

#Identifier
cc <- grepl("^[A-Z][0-9][0-9][0-9][0-9]", Dat$Object)
Dat$OtherInfo[cc] <- "identifier"
Dat$ObjInfo[cc] <- paste0("identifier:", stringr::str_sub(Dat$Object[cc], start=1, end=1))
#head(Dat[cc,])

#head(Dat)
Dat[is.na(Dat$OtherInfo),"OtherInfo"] <- "BLANK"
saveRDS(Dat, paste0(sub(".nt$", "", File_path), "_df_R01.Rds"))

#Use the below propertys for researching the class hierarchy.
# meshv:broaderDescriptor
# meshv:broaderConcept
# meshv:concept => reverseConcept
# meshv:narrowerConcept => reverseNarrowerConcept
# meshv:preferredConcept
# meshv:preferredConcept => reversePreferredConcept

##Check
#head(Dat); dim(Dat); table(Dat$Property)

#001
List <- c("meshv:broaderDescriptor", "meshv:broaderConcept", "meshv:preferredConcept")
Dat.bDes <- Dat[Dat$Property %in% List,]
#head(Dat.bDes)
#table(Dat.bDes$Property)
#table(Dat.bDes$SubInfo, Dat.bDes$Property)
#table(Dat.bDes$Property, Dat.bDes$ObjInfo )

##meshv:broaderConcept
#Dat.bDesR <- Dat.bDes[Dat.bDes$Property == "meshv:broaderConcept",]
#table(Dat.bDesR$SubInfo, Dat.bDesR$Property)
#table(Dat.bDesR$Property, Dat.bDesR$ObjInfo )
#head(Dat.bDesR); dim(Dat.bDesR)
#a <- Dat.bDesR[Dat.bDesR$Subject %in% Dat.bDesR$Object,]
#dim(a)

##meshv:broaderDescriptor
#Dat.bDesRR <- Dat.bDes[Dat.bDes$Property == "meshv:broaderDescriptor",]
#table(Dat.bDesRR$SubInfo, Dat.bDesRR$Property)
#table(Dat.bDesRR$Property, Dat.bDesRR$ObjInfo )
#head(Dat.bDesRR); dim(Dat.bDesRR)
#a <- Dat.bDesRR[Dat.bDesRR$Subject %in% Dat.bDesRR$Object,]
#dim(a)
#b <- Dat.bDesRR[Dat.bDesRR$Subject %in% a$Object,]
#dim(b)

#ここまで
#002: meshv:concept
Dat.concept <- Dat[Dat$Property == "meshv:concept",]
table(Dat.concept$SubInfo, Dat.concept$Property)
table(Dat.concept$Property, Dat.concept$ObjInfo )

Dat.conceptR <- Dat.concept
Dat.concept$Subject <- Dat.conceptR$Object
Dat.concept$Property <- "reverseConcept"
Dat.concept$Object <- Dat.conceptR$Subject
Dat.concept$SubInfo <- Dat.conceptR$ObjInfo
Dat.concept$ObjInfo <- Dat.conceptR$SubInfo
table(Dat.concept$SubInfo, Dat.concept$Property)
table(Dat.concept$Property, Dat.concept$ObjInfo )

Dat.nCC <- Dat[Dat$Property == "meshv:narrowerConcept" | Dat$Property == "meshv:broaderConcept",]
table(Dat.nCC$SubInfo, Dat.nCC$Property)
table(Dat.nCC$Property, Dat.nCC$ObjInfo )
#head(Dat.nCC, n=20)
#head(Dat.nCC[Dat.nCC$Subject == "mesh:M0000037",])
dim(Dat.nCC)
a <- Dat.nCC[Dat.nCC$Subject %in% Dat.nCC$Object,]
dim(a)
b <- Dat.nCC[Dat.nCC$Subject %in% a$Object,]
dim(b)

#003: meshv:narrowerConcept
Dat.nC <- Dat[Dat$Property == "meshv:narrowerConcept",]
table(Dat.nC$SubInfo, Dat.nC$Property)
table(Dat.nC$Property, Dat.nC$ObjInfo )
head(Dat.nC)
dim(Dat.nC)
a <- Dat.nC[Dat.nC$Subject %in% Dat.nC$Object,]
dim(a)
b <- Dat.nC[Dat.nC$Subject %in% a$Object,]
dim(b)

Dat.nCR <- Dat.nC
Dat.nC$Subject <- Dat.nCR$Object
Dat.nC$Property <- "reverseNarrowerConcept"
Dat.nC$Object <- Dat.nCR$Subject
Dat.nC$SubInfo <- Dat.nCR$ObjInfo
Dat.nC$ObjInfo <- Dat.nCR$SubInfo

#004: meshv:preferredConcept
Dat.pC <- Dat[Dat$Property == "meshv:preferredConcept",]
table(Dat.pC$SubInfo, Dat.pC$Property)
table(Dat.pC$Property, Dat.pC$ObjInfo )

Dat.pCR <- Dat.pC
Dat.pC$Subject <- Dat.pCR$Object
Dat.pC$Property <- "reversePreferredConcept"
Dat.pC$Object <- Dat.pCR$Subject
Dat.pC$SubInfo <- Dat.pCR$ObjInfo
Dat.pC$ObjInfo <- Dat.pCR$SubInfo

library(magrittr)
DatR <- Dat.bDes %>%
  rbind(Dat.concept) %>%
  rbind(Dat.nC) %>%
  rbind(Dat.pC)

table(DatR$SubInfo, DatR$Property)
table(DatR$Property, DatR$ObjInfo)
DatR <- DatR[DatR$SubInfo != "IDs:mesh:Q",]
DatR <- DatR[DatR$SubInfo != "IDs:mesh:C",]
DatR <- DatR[DatR$ObjInfo != "IDs:mesh:Q",]
DatR <- DatR[DatR$ObjInfo != "IDs:mesh:C",]
dim(DatR)
table(DatR$SubInfo, DatR$Property)
table(DatR$Property, DatR$ObjInfo)

table(DatR$Property)
saveRDS(DatR, "./00_Mesh_Input/mesh2021_others_df_RR.Rds")

}

#head(Dat)

return(message("Finished!!"))

}











