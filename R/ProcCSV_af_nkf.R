##' @title Processing after the conversion to the Multi-Byte Character.
##'
##' @param File_path a character vector for a N-triple (NT) file (.nt) or CSV file.
##'
##' @description This function provide a Processing after the conversion from
##' their unicode (Escape character) to Multi-Byte Character (Japanese).
##'
##' @return Rds
##' @author Satoshi Kume
##' @export ProcCSV_af_nkf
##'
##' @importFrom magrittr %>%
##' @importFrom stringr str_detect
##' @importFrom readr read_csv
##' @importFrom knitr kable
##' @importFrom stringr str_sub
##'
##' @examples \dontrun{
##'
##' File_path <- "./Label_en_rdfs.nt"
##' ProcCSV_af_nkf(File_path)
##'
##' }
##'

ProcCSV_af_nkf <- function(File_path){
if(!any(grepl(".nt$", File_path), grepl(".csv$", File_path))){
  return(message("Warning: Not proper value of File_path"))
}

if(grepl(".nt$", File_path)){
Dat <- data.frame(readr::read_csv(paste0(sub(".nt$", "", File_path), "_df.csv"),
                                  col_names = FALSE, show_col_types = FALSE))
}

if(grepl(".csv$", File_path)){
Dat <- data.frame(readr::read_csv(File_path,
                                  col_names = FALSE, show_col_types = FALSE))
}

#head(Dat)
TypeL <- ncol(Dat)
switch(as.character(TypeL),
       "3" = colnames(Dat) <- c("Subject", "Property", "Object"),
       "4" = colnames(Dat) <- c("Subject", "Property", "Object", "OtherInfo")
       )

Dat %>%
  head() %>%
  knitr::kable(format = "pipe", booktabs = T, align = "c") %>%
  print()

YN <- askYesNo("Is it OK to go to the next step?")
if(!YN){return(message("No save"))}

#head(Dat)
Dat[,1] <- sub("^\"", "", Dat[,1])
Dat[,1] <- sub("\"$", "", Dat[,1])
Dat[,2] <- sub("^\"", "", Dat[,2])
Dat[,2] <- sub("\"$", "", Dat[,2])

Dat[,3] <- sub("^\"\\\\\"", "", Dat[,3])
Dat[,3] <- sub("\"$", "", Dat[,3])

if(grepl(".nt$", File_path)){
lang <- stringr::str_sub(Dat[,3], start=-3, end=-1)
Dat[,3] <- sub("\\\\\"@ja$", "", Dat[,3])
Dat[,3] <- sub("\\\\\"@en$", "", Dat[,3])
Dat$OtherInfo <- lang
}

if(any(stringr::str_detect(Dat[,3], pattern = "\\\\"), na.rm = TRUE)){
for(n in 1:6){Dat[,3] <- sub("\\\\", "", Dat[,3])}
}

if(any(stringr::str_detect(Dat[,3], pattern = "\\\\"), na.rm = TRUE)){
for(n in 1:6){Dat[,3] <- sub("\\\\", "", Dat[,3])}
}

message(paste0('dim(Dat): ', paste0(dim(Dat), collapse = " ")))
saveRDS(Dat, file = paste0(sub("_df_nkf.csv$", "", sub(".nt$", "", File_path)), "_df.Rds"))
return( message("Finished!!") )

}

