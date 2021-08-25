##' @title Convert labels to CSV file
##'
##' @param File_path a character vector for a N-triple (NT) file (.nt).
##'
##' @description This function convert the NT file from the Mesh dump
##' to CSV file.
##'
##' @return CSV file
##' @author Satoshi Kume
##' @export PurseNT_Label
##' @importFrom readr write_csv
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

PurseNT_Label <- function(File_path,
                               Subject=c("http://id.nlm.nih.gov/mesh/2019/", "mesh2019:",
                                         "http://id.nlm.nih.gov/mesh/2020/", "mesh2020:",
                                         "http://id.nlm.nih.gov/mesh/2021/", "mesh2021:",
                                         "http://id.nlm.nih.gov/mesh/", "mesh:"),
                               Property=c("http://id.nlm.nih.gov/mesh/vocab#", "meshv:",
                                          "http://www.w3.org/1999/02/22-rdf-syntax-ns#", "rdf:",
                                          "http://www.w3.org/2000/01/rdf-schema#", "rdfs:")){
if(!grepl(".nt$", File_path)){return(message("Warning: Not proper value of File_path"))}

message(paste0("Read data"))
a <- readr::read_lines(File_path)
a <- a[!grepl("^# <http://id.nlm.nih.gov/mesh>", a)]
#head(a)

#\t to space
if(any(grepl(">\t", a))){
a <- sub(">\t", "> ", a)
a <- sub(">\t", "> ", a)
}

message(paste0("Split data"))

#AiBiCiDiEiFiG: Unique arbitrary string
a1 <- unlist(strsplit(sub(" ", "AiBiCiDiEiFiG", sub(" ", "AiBiCiDiEiFiG", a)), split="AiBiCiDiEiFiG"))
if( ( length(a1) %% 3 ) == 0 ){
  b <- matrix(a1, ncol=3, byrow=T)
}else{
  b <- matrix(a1[1:(length(a1) - (length(a1) %% 3))], ncol=3, byrow=T)
}

message(paste0("Remove [.]$"))
b[,3] <- sub(" [.]$", "", b[,3])

#head(b); dim(b)
message(paste0("Convert matrix to DF"))
d <- data.frame(b)
#head(d)

#Prefix
message(paste0("Prefix: Subject"))

#Subject
#head(d)
for(n in seq_len(length(Subject)/2)){
#n <- 1
cc <- grepl(paste0("^<", Subject[2*n-1]), d[,1])
d[cc,1] <- sub(paste0("^<", Subject[2*n-1]), Subject[2*n], d[cc,1])
d[cc,1] <- sub(">$", "", d[cc,1])
}

#Property
message(paste0("Prefix: Property"))
for(n in seq_len(length(Property)/2)){
#n <- 1
cc <- grepl(paste0("^<", Property[2*n-1]), d[,2])
d[cc,2] <- sub(paste0("^<", Property[2*n-1]), Property[2*n], d[cc,2])
d[cc,2] <- sub(">$", "", d[cc,2])
}

#head(d)
#table(d$X2)
#table(grepl("@en", d$X3))

#X4
message( paste0("Proc: Object & others") )
d$X4 <- "BLANK"
cc <- grepl("@en$", d[,3])
d[cc,4] <- "@en"
d[cc,3] <- sub("@en$", "", d[cc,3])
d[cc,3] <- stringr::str_sub(d[cc,3], start = 2, end = -2)
#head(d)

message(paste0("Save as CSV"))
readr::write_csv(d,
                 file=paste0(sub(".nt$", "", File_path), "_df.csv"),
                 append=FALSE, col_names = FALSE, na = "")
message(paste0("Finished!!"))

}
