##' @title Convert the class hierarchy to CSV file for Mesh dump
##'
##' @param File_path a character vector for a N-triple (NT) file (.nt).
##'
##' @description This function convert the NT file
##' from the Mesh dump to CSV file.
##'
##' @return CSV file
##' @author Satoshi Kume
##' @export Mesh_PurseNT
##' @importFrom readr write_csv
##' @importFrom readr read_lines
##'
##' @examples \dontrun{
##'
##' #Class hierarchy
##' File_path <- "./mesh2019_others2.nt"
##'
##' # Run
##' Mesh_PurseNT(File_path)
##' DFcsv2Rdata(File_path)
##'
##' }
##'

Mesh_PurseNT <- function(File_path,
                         Subject=c("http://id.nlm.nih.gov/mesh/2019/", "mesh2019:"),
                         Property=c("http://id.nlm.nih.gov/mesh/vocab#", "meshv:"),
                         Object=c("http://id.nlm.nih.gov/mesh/2019/", "mesh2019:")
                         ){

if(!grepl(".nt$", File_path)){return(message("Warning: Not proper value of File_path"))}

message(print0("Read data"))
a <- readr::read_lines(File_path)
#head(a)

#AiBiCiDiEiFiG: Unique arbitrary string
a1 <- unlist(strsplit(sub(" ", "AiBiCiDiEiFiG", sub(" ", "AiBiCiDiEiFiG", a)), split="AiBiCiDiEiFiG"))
if( (length(a1) %% 3) == 0 ){
  b <- matrix(a1, ncol=3, byrow=T)
}else{
  b <- matrix(a1[1:(length(a1) - (length(a1) %% 3))], ncol=3, byrow=T)
}

message(print0("remove [.]"))
b[,3] <- sub(" [.]$", "", b[,3])

#head(b); dim(b)
message(print0("convert matrix to DF"))
d <- data.frame(b)

#Prefix
message(print0("Prefix: Subject"))
#Subject=c("http://id.nlm.nih.gov/mesh/2019/", "mesh2019:"),
for(n in seq_len(length(Subject)/2)){
#n <- 1
cc <- grepl(paste0("^<", Subject[2*n-1]), d[,1])
d[cc,1] <- sub(paste0("^<", Subject[2*n-1]), Subject[2*n], d[cc,1])
d[cc,1] <- sub(">$", "", d[cc,1])
}

#Property=c("http://id.nlm.nih.gov/mesh/vocab#", "meshv:"),
message(print0("Prefix: Property"))
for(n in seq_len(length(Property)/2)){
#n <- 1
cc <- grepl(paste0("^<", Property[2*n-1]), d[,2])
d[cc,2] <- sub(paste0("^<", Property[2*n-1]), Property[2*n], d[cc,2])
d[cc,2] <- sub(">$", "", d[cc,2])
}

#Object=c("http://id.nlm.nih.gov/mesh/2019/", "mesh2019:")
message(print0("Prefix: Object"))
for(n in seq_len(length(Object)/2)){
#n <- 1
cc <- grepl(paste0("^<", Object[2*n-1]), d[,2])
d[cc,2] <- sub(paste0("^<", Object[2*n-1]), Object[2*n], d[cc,2])
d[cc,2] <- sub(">$", "", d[cc,2])
}

#head(d)
message(print0("Save as CSV"))
readr::write_csv(d,
                 file=paste0(sub(".nt$", "", File_path), "_df.csv"),
                 append=FALSE, col_names = FALSE)

}

