##' @title Convert CSV file to Rdata
##'
##' @param File_path a character vector for a N-triple (NT) file (.nt).
##'
##' @description This function convert the CSV file gained through the
##' PurseNT functions to Rdata. Then it check the data table.
##'
##' @return Rdata
##' @author Satoshi Kume
##' @export DFcsv2Rdata
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
##' DFcsv2Rdata(File_path)
##'
##' }
##'

DFcsv2Rdata <- function(File_path){
if(!grepl(".nt$", File_path)){return(message("Warning: Not proper value of File_path"))}
if(any(dir() == sub("^./", "", paste0(sub(".nt$", "", File_path), "_df.Rdata")))){
  file.remove(paste0(sub(".nt", "", File_path), "_df.Rdata"))
  }
Dat <- data.frame(readr::read_csv(paste0(sub(".nt$", "", File_path), "_df.csv"),
                                  col_names = FALSE))

Dat %>%
  head() %>%
  knitr::kable(format = "pipe", booktabs = T, align = "c") %>%
  print()

YN <- askYesNo("Do you want to save its Rdata?")
if(!YN){return(message("No save"))}

message(paste0('dim(Dat): ', paste0(dim(Dat), collapse = " ")))
message(paste0('sum(grepl("^wd:", Dat[,1])): ', sum(grepl("^wd:", Dat[,1]))))
message(paste0('sum(grepl("^wdt:", Dat[,2])): ', sum(grepl("^wdt:", Dat[,2]))))
message(paste0('sum(grepl("^wd:", Dat[,3])): ', sum(grepl("^wd:", Dat[,3]))))

saveRDS(Dat, file = paste0(sub(".nt$", "", File_path), "_df.Rdata"))
return(message("Finished!!"))

}





