##' @title Convert TSV file to Rds file
##'
##' @param File_path a character vector for a N-triple (NT) file (.nt).
<<<<<<< HEAD
##' @param Type a type of dataset; select it from Mesh, MeshLabel, wikidata, wikilabel, CHEBI, CHEBIlabel and ID
=======
>>>>>>> b55e2115b3493440c16d6bad9cfe565a6455bd53
##'
##' @description This function convert the TSV file gained through the
##' PurseNT functions to Rds. Then it check the data table.
##'
##' @return Rds
##' @author Satoshi Kume
##' @export DFtsv2Rds
##' @importFrom readr read_tsv
##' @importFrom knitr kable
##' @importFrom magrittr %>%
##'
##' @examples \dontrun{
<<<<<<< HEAD
##' #Not Run
=======
##'
>>>>>>> b55e2115b3493440c16d6bad9cfe565a6455bd53
##' #rdfs:label
##' File_path <- "./Label_en_rdfs.nt"
##'
##' #Run
##' PurseNT_Label(File_path, tsv=TRUE)
##' DFtsv2Rds(File_path)
##'
##' }
##'

DFtsv2Rds <- function(File_path, Type){
<<<<<<< HEAD
if(length(Type) != 1){ return(message("Warning: No proper value of Type")) }
if(!any(Type == c("Mesh", "MeSH", "mesh", "MeshLabel", "meshlabel",
                  "Wikidata", "wikidata", "WikiData", "ID",
                  "wikilabel", "wikiLabel", "WikiLabel", "Wikilabel",
                  "CHEBI", "ChEBI", "chebi",
                  "CHEBIlabel", "ChEBIlabel", "chebilabel",
                  "CHEBILabel", "ChEBILabel", "chebiLabel"))){
=======
if(!any(Type == c("Mesh", "MeSH", "mesh", "MeshLabel", "meshlabel",
                  "Wikidata", "wikidata", "WikiData", "ID",
                  "wikilabel", "wikiLabel", "WikiLabel", "Wikilabel"))){
>>>>>>> b55e2115b3493440c16d6bad9cfe565a6455bd53
  return(message("Warning: No proper value of Type"))
}

if(grepl("_df.tsv$", File_path)){ File_path <- sub("_df.tsv$", ".nt", File_path) }
if(grepl("_df_nkf.tsv$", File_path)){ File_path <- sub("_df_nkf.tsv$", ".nt", File_path) }
if(!grepl(".nt$", File_path)){ return(message("Warning: No proper value of File_path")) }
if(any(dir() == sub("^./", "", paste0(sub(".nt$", "", File_path), "_df.Rds")))){
  file.remove(paste0(sub(".nt", "", File_path), "_df.Rds"))
}

message(paste0("Read data"))
if(grepl(".nt$", File_path)){
Dat <- data.frame(readr::read_tsv(paste0(sub(".nt$", "", File_path), "_df.tsv"),
                                  col_names = FALSE, progress=F, show_col_types = FALSE))
}
if(grepl("_df_nkf.nt$", File_path)){
Dat <- data.frame(readr::read_tsv(paste0(sub(".nt$", "", File_path), ".tsv"),
                                  col_names = FALSE, progress=F, show_col_types = FALSE))
}

#head(Dat)
#table(Dat$X4)
TypeL <- tolower(Type)
switch(TypeL,
<<<<<<< HEAD
       "mesh" = if(ncol(Dat) != 4){return(message("Warning: No proper value of Data"))},
       "meshlabel" = if(ncol(Dat) != 4){return(message("Warning: No proper value of Data"))},
       "wikidata" = if(ncol(Dat) != 3){return(message("Warning: No proper value of Data"))},
       "wikilabel" = if(ncol(Dat) != 4){return(message("Warning: No proper value of Data"))},
       "chebi" = if(ncol(Dat) != 3){return(message("Warning: No proper value of Data"))},
       "chebilabel" = if(ncol(Dat) != 4){return(message("Warning: No proper value of Data"))},
       "id" = if(ncol(Dat) != 3){return(message("Warning: No proper value of Data"))}
       )

switch(TypeL,
=======
>>>>>>> b55e2115b3493440c16d6bad9cfe565a6455bd53
       "mesh" = colnames(Dat) <- c("Subject", "Property", "Object", "OtherInfo"),
       "meshlabel" = colnames(Dat) <- c("Subject", "Property", "Object", "OtherInfo"),
       "wikidata" = colnames(Dat) <- c("Subject", "Property", "Object"),
       "wikilabel" = colnames(Dat) <- c("Subject", "Property", "Object", "OtherInfo"),
<<<<<<< HEAD
       "chebi" = colnames(Dat) <- c("Subject", "Property", "Object"),
       "chebilabel" = colnames(Dat) <- c("Subject", "Property", "Object", "OtherInfo"),
=======
>>>>>>> b55e2115b3493440c16d6bad9cfe565a6455bd53
       "id" = colnames(Dat) <- c("Subject", "Property", "Object")
       )

message(paste0('dim(Dat): ', paste0(dim(Dat), collapse = " ")))

if(any(colnames(Dat) == "OtherInfo")){
  message('table(Dat$OtherInfo): ')
  print(table(Dat$OtherInfo))
}

switch(Type,
       "ID" = Dat <- Dat[!is.na(Dat$Object),]
       )

Dat %>%
  head() %>%
  knitr::kable(format = "pipe", booktabs = T, align = "c") %>%
  print()

YN <- askYesNo("Do you want to save its Rds?")
if(!YN){return(message("No save"))}

#Remove loops
if(TypeL == "wikidata"){
#head(Dat)
message("Remove loops")
Dat <- Dat[Dat$Subject != as.character(Dat$Object),]
}

<<<<<<< HEAD
if(TypeL == "wikilabel"){
message("Remove \\\\\\\\")
if(any(stringr::str_detect(Dat[,3], pattern = "\\\\\\\\"), na.rm = TRUE)){
for(n in 1:6){Dat[,3] <- sub("\\\\\\\\", " ", Dat[,3])}
}
=======
#Remove \\\\\\\\ etc
>>>>>>> b55e2115b3493440c16d6bad9cfe565a6455bd53
if(any(stringr::str_detect(Dat[,3], pattern = "\\\\\\\\"), na.rm = TRUE)){
for(n in 1:6){Dat[,3] <- sub("\\\\\\\\", " ", Dat[,3])}
}
if(any(stringr::str_detect(Dat[,3], pattern = "\\\\\\\\"), na.rm = TRUE)){
for(n in 1:6){Dat[,3] <- sub("\\\\\\\\", " ", Dat[,3])}
}

#Change double spaces to single space
<<<<<<< HEAD
message("Change double spaces to single space")
if(any(stringr::str_detect(Dat[,3], pattern = "  "), na.rm = TRUE)){
for(n in 1:6){Dat[,3] <- sub("  ", " ", Dat[,3])}
}
if(any(stringr::str_detect(Dat[,3], pattern = "  "), na.rm = TRUE)){
for(n in 1:6){Dat[,3] <- sub("  ", " ", Dat[,3])}
}
=======
if(any(stringr::str_detect(Dat[,3], pattern = "[ ][ ]"), na.rm = TRUE)){
for(n in 1:6){Dat[,3] <- sub("[ ][ ]", "[ ]", Dat[,3])}
>>>>>>> b55e2115b3493440c16d6bad9cfe565a6455bd53
}

message(paste0('dim(Dat): ', paste0(dim(Dat), collapse = " ")))
saveRDS(Dat, file = paste0(sub(".nt$", "", File_path), "_df.Rds"))

return(message("Finished!!"))

}








