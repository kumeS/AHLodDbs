##' @title Convert labels to CSV file for Wikidata dump
##'
##' @param File_path a character vector for a N-triple (NT) file (.nt).
##'
##' @description This function convert the NT file from the Wikidata dump
##' to CSV file.
##'
##' @return CSV file
##' @author Satoshi Kume
##' @export Wikidata_PurseNT_Label
##' @importFrom readr write_csv
##'
##' @examples \dontrun{
##'
##' #rdfs:label
##' File_path <- "./Label_en_rdfs.nt"
##'
##' #Run
##' Wikidata_PurseNT_Label(File_path)
##' DFcsv2Rds(File_path)
##'
##' }
##'

Wikidata_PurseNT_Label <- function(File_path){
if(!grepl(".nt$", File_path)){return(message("Warning: Not proper value of File_path"))}
con_file <- file(description = File_path, open = "r")
print(con_file)

#Execution number
x <- 0

#Rows per read
N <- 100000

while( TRUE ){
x <- x + 1
message(paste0("No: ", formatC(x, width=4, flag="0"), " read lines: ", x*N ))
try(a <- readLines(con_file, n = N), silent=T)
if ( length(a) == 0 ) { close(con_file); break }

#AiBiCiDiEiFiG: Unique arbitrary string
a1 <- unlist(strsplit(sub(" ", "AiBiCiDiEiFiG", sub(" ", "AiBiCiDiEiFiG", a)), split="AiBiCiDiEiFiG"))
if( (length(a1) %% 3) == 0 ){
  b <- matrix(a1, ncol=3, byrow=T)
}else{
  b <- matrix(a1[1:(length(a1) - (length(a1) %% 3))], ncol=3, byrow=T)
}

#remove [.]
b[,3] <- sub(" [.]$", "", b[,3])

#Subject
cc <- grepl("^<http://www.wikidata.org/entity/Q[0-9]", b[,1])
b[cc,1] <- sub("^<http://www.wikidata.org/entity/", "wd:", b[cc,1])
b[cc,1] <- sub(">$", "", b[cc,1])
b <- b[grepl("^wd:Q", b[,1]),]

#Property
b[,2] <- sub("<http://www.w3.org/2000/01/rdf-schema#label>", "rdfs:label", b[,2])
b[,2] <- sub("<http://www.w3.org/2004/02/skos/core#prefLabel>", "skos:prefLabel", b[,2])
b[,2] <- sub("<http://www.w3.org/2004/02/skos/core#altLabel>", "skos:altLabel", b[,2])
b[,2] <- sub("<http://schema.org/description>", "schema:description", b[,2])
b[,2] <- sub("<http://schema.org/name>", "schema:name", b[,2])
b <- b[grepl("^rdfs|^skos|^schema", b[,2]),]

#convert matrix to DF
b <- data.frame(b)
#head(b)

#Object
b$X4 <- NA
b[,4][grepl("@ja$", b[,3])] <- "@ja"
b[,4][grepl("@en$", b[,3])] <- "@en"
b[,3] <- sub("@ja$", "", b[,3])
b[,3] <- sub("@en$", "", b[,3])
b[,3] <- sub('"$', '', b[,3])
b[,3] <- sub('^"', '', b[,3])

#head(b); dim(b)

#convert matrix to DF
d <- data.frame(b)

if(x == 1){
readr::write_csv(d,
                 file=paste0(sub(".nt$", "", File_path), "_df.csv"),
                 append=FALSE, col_names = FALSE)
}else{
readr::write_csv(d,
                 file=paste0(sub(".nt$", "", File_path), "_df.csv"),
                 append=TRUE, col_names = FALSE)
}}
#close(con_file)
}
