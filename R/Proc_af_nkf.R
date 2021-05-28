##' @title Processing after the conversion to the Multi-Byte Character.
##'
##' @param File_path a character vector for a N-triple (NT) file (.nt).
##'
##' @description This function provide a Processing after the conversion from
##' their unicode (Escape character) to Multi-Byte Character (Japanese).
##'
##' @return Rdata
##' @author Satoshi Kume
##' @export Proc_af_nkf
##' @importFrom magrittr %>%
##'
##' @examples \dontrun{
##'
##' File_path <- "./Label_en_rdfs.nt"
##' Proc_af_nkf(File_path)
##'
##' }
##'

Proc_af_nkf <- function(File_path){
if(!grepl(".nt$", File_path)){return(message("Warning: Not proper value of File_path"))}
Dat <- data.frame(readr::read_csv(paste0(sub(".nt$", "", File_path), "_df.csv"), col_names = FALSE))

Dat %>%
  head() %>%
  knitr::kable(format = "pipe", booktabs = T, align = "c") %>%
  print()

YN <- askYesNo("Is it OK to go to the next step next?")
if(!YN){return(message("No save"))}

#head(b)
b[,1] <- sub("^\"", "", b[,1])
b[,1] <- sub("\"$", "", b[,1])
b[,2] <- sub("^\"", "", b[,2])
b[,2] <- sub("\"$", "", b[,2])

b[,3] <- sub("^\"\\\\\"", "", b[,3])
b[,3] <- sub("\"$", "", b[,3])
lang <- stringr::str_sub(b[,3], start=-3, end=-1)
b[,3] <- sub("\\\\\"@ja$", "", b[,3])
b[,3] <- sub("\\\\\"@en$", "", b[,3])

if(stringr::str_detect(b[,3], pattern = "\\\\")){
for(n in 1:6){b[,3] <- sub("\\\\", "", b[,3])}
}

}
