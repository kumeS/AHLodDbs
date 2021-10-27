##' @title Convert the class hierarchy to CSV file for Wikidata dump
##'
##' @param File_path a character vector for a N-triple (NT) file (.nt).
##'
##' @description This function convert the NT file from the
##' Wikidata dump to CSV file.
##'
##' @return CSV file
##' @author Satoshi Kume
##' @export Wikidata_PurseNT_ClassHierarchy
##' @importFrom readr write_csv
##'
##' @examples \dontrun{
##'
##' #Class hierarchy
##' File_path <- "./Relation_P279_P31.nt"
##'
##' #Run
##' Wikidata_PurseNT_ClassHierarchy(File_path)
##' DFcsv2Rdata(File_path)
##'
##' }
##'

Wikidata_PurseNT_ClassHierarchy <- function(File_path){
if(!grepl(".nt$", File_path)){return(message("Warning: Not proper value of File_path"))}
con_file <- file(description = File_path, open = "r")
print(con_file)

#Execution number
x <- 0
#Rows per read
N <- 100000

#Purse NT file to CSV
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

# remove [.]
b[,3] <- sub(" [.]$", "", b[,3])

#Subject
cc <- grepl("^<http://www.wikidata.org/entity/Q[0-9]", b[,1])
b[cc,1] <- sub("^<http://www.wikidata.org/entity/", "wd:", b[cc,1])
b[cc,1] <- sub(">$", "", b[cc,1])
b <- b[grepl("^wd:Q", b[,1]),]

#Property
cc <- grepl("^<http://www.wikidata.org/prop/direct/P[0-9]", b[,2])
b[cc,2] <- sub("^<http://www.wikidata.org/prop/direct/", "wdt:", b[cc,2])
b[cc,2] <- sub(">$", "", b[cc,2])
b <- b[grepl("^wdt:P", b[,2]),]

#Object
cc <- grepl("^<http://www.wikidata.org/entity/Q[0-9]", b[,3])
b[cc,3] <- sub("^<http://www.wikidata.org/entity/", "wd:", b[cc,3])
b[cc,3] <- sub(">$", "", b[cc,3])
b <- b[grepl("^wd:Q", b[,3]),]

#head(b); dim(b)

#convert matrix to DF
d <- data.frame(b)
#head(d); dim(d)

if(any(unique(d$X2) == "wdt:P279")){
  d$X2[d$X2 == "wdt:P279"] <- "rdfs:subClassOf"
}
if(any(unique(d$X2) == "wdt:P31")){
  d$X2[d$X2 == "wdt:P31"] <- "rdf:instanceOf"
}

if(x == 1){
readr::write_csv(d,
                 file=paste0(sub(".nt$", "", File_path), "_df.csv"),
                 append=FALSE, col_names = FALSE)
}else{
readr::write_csv(d,
                 file=paste0(sub(".nt$", "", File_path), "_df.csv"),
                 append=TRUE, col_names = FALSE)
}}
}
