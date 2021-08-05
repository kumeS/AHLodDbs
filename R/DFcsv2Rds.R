##' @title Convert CSV file to Rds file
##'
##' @param File_path a character vector for a N-triple (NT) file (.nt).
##'
##' @description This function convert the CSV file gained through the
##' PurseNT functions to Rds. Then it check the data table.
##'
##' @return Rds
##' @author Satoshi Kume
##' @export DFcsv2Rds
##' @importFrom readr read_csv
##' @importFrom knitr kable
##' @importFrom magrittr %>%
##'
##' @examples \dontrun{
##'
##' #rdfs:label
##' File_path <- "./Label_en_rdfs.nt"
##'
##' #Run
##' PurseNT_Label(File_path)
##' DFcsv2Rds(File_path)
##'
##' }
##'

DFcsv2Rds <- function(File_path, Type){
if(!any(Type == c("Mesh", "MeSH", "mesh", "MeshLabel", "meshlabel",
                  "Wikidata", "wikidata", "WikiData", "ID"))){
  return(message("Warning: No proper value of Type"))
}

if(grepl("_df.csv$", File_path)){ File_path <- sub("_df.csv$", ".nt", File_path) }
if(!grepl(".nt$", File_path)){ return(message("Warning: No proper value of File_path")) }
if(any(dir() == sub("^./", "", paste0(sub(".nt$", "", File_path), "_df.Rds")))){
  file.remove(paste0(sub(".nt", "", File_path), "_df.Rds"))
}

message(paste0("Read data"))
Dat <- data.frame(readr::read_csv(paste0(sub(".nt$", "", File_path), "_df.csv"),
                                  col_names = FALSE, progress=F))

#head(Dat)
TypeL <- tolower(Type)
switch(TypeL,
       "mesh" = colnames(Dat) <- c("Subject", "Property", "Object", "OtherInfo"),
       "meshlabel" = colnames(Dat) <- c("Subject", "Property", "Object", "OtherInfo"),
       "wikidata" = colnames(Dat) <- c("Subject", "Property", "Object"),
       "id" = colnames(Dat) <- c("Subject", "Property", "Object")
       )

message(paste0('dim(Dat): ', paste0(dim(Dat), collapse = " ")))

switch(Type,
       "ID" = Dat <- Dat[!is.na(Dat$Object),]
       )

Dat %>%
  head() %>%
  knitr::kable(format = "pipe", booktabs = T, align = "c") %>%
  print()

YN <- askYesNo("Do you want to save its Rds?")
if(!YN){return(message("No save"))}

message(paste0('dim(Dat): ', paste0(dim(Dat), collapse = " ")))
saveRDS(Dat, file = paste0(sub(".nt$", "", File_path), "_df.Rds"))

return(message("Finished!!"))

}





