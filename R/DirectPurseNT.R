##' @title Directly convert NT file to each file
##'
##' @param File_path a character vector for a N-triple (NT) file (.nt).
##' @param Type a type of dataset; select only Wikidata, CHEBI, or Mesh.
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
##' #Not Run
##' #rdfs:label
##' File_path <- "./Label_en_rdfs.nt"
##'
##' #Run
##' PurseNT_Label(File_path, tsv=TRUE)
##' DFtsv2Rds(File_path)
##'
##' }
##'


DirectPurseNT <- function(File_path,
                          Type="Wikidata"){

if(length(Type) != 1){ return(message("Warning: No proper value of Type")) }
if(!any(Type == c("Wikidata", "wikidata", "WikiData",
                  "CHEBI", "ChEBI", "chebi",
                  "Mesh", "MeSH", "mesh"))){
  return(message("Warning: No proper value of Type"))
}

TypeL <- tolower(Type)

## wikidata
if(TypeL == "wikidata"){
if(!grepl(".nt$", File_path)){return(message("Warning: Not proper value of File_path"))}
con_file <- file(description = File_path, open = "r")
print(con_file)

#Execution number
x <- 0
x1 <- 0
x2 <- 0
x3 <- 0
x4 <- 0
x5 <- 0

#Rows per read
N <- 100000

#Purse NT file to CSV
while( TRUE ){
x <- x + 1
message(paste0("No: ", formatC(x, width=4, flag="0"), " read lines: ", x*N ))
try(a <- readLines(con_file, n = N), silent=T)
if ( length(a) == 0 ) { close(con_file); break }

#head(a)

##extract English labels
cc <- grepl("@en [.]$", a)
b <- a[cc]
if(!identical(b, character(0))){
d <- b[grepl(" <http://www.w3.org/2000/01/rdf-schema#label> ", b)]
if(!identical(d, character(0))){
x1 <- x1 + 1
if(x1 == 1){
readr::write_lines(d,
                   file="Label_en_rdfs.nt",
                   append=FALSE, col_names = FALSE)
}else{
readr::write_lines(d,
                   file="Label_en_rdfs.nt",
                   append=TRUE, col_names = FALSE)
}
}

d <- b[grepl(" <http://www.w3.org/2004/02/skos/core#altLabel> ", b)]
if(!identical(d, character(0))){
x2 <- x2 + 1
if(x2 == 1){
readr::write_lines(d,
                   file="Label_en_Altlabel.nt",
                   append=FALSE, col_names = FALSE)
}else{
readr::write_lines(d,
                   file="Label_en_Altlabel.nt",
                   append=TRUE, col_names = FALSE)
}
}
}

##extract Japanese labels
cc <- grepl("@ja [.]", a)
b <- a[cc]
if(!identical(b, character(0))){
d <- b[grepl(" <http://www.w3.org/2000/01/rdf-schema#label> ", b)]
if(!identical(d, character(0))){
x3 <- x3 + 1
if(x3 == 1){
readr::write_lines(d,
                   file="Label_ja_rdfs.nt",
                   append=FALSE, col_names = FALSE)
}else{
readr::write_lines(d,
                   file="Label_ja_rdfs.nt",
                   append=TRUE, col_names = FALSE)
}
}

d <- b[grepl(" <http://www.w3.org/2004/02/skos/core#altLabel> ", b)]
if(!identical(d, character(0))){
x4 <- x4 + 1
if(x4 == 1){
readr::write_lines(d,
                   file="Label_ja_Altlabel.nt",
                   append=FALSE, col_names = FALSE)
}else{
readr::write_lines(d,
                   file="Label_ja_Altlabel.nt",
                   append=TRUE, col_names = FALSE)
}
}
}

##extract class hierarchy
d <- a[grepl(" <http://www.wikidata.org/prop/direct/P279> ", a)]
if(!identical(d, character(0))){
x5 <- x5 + 1
if(x5 == 1){
readr::write_lines(d,
                   file="Relation_P279_P31.nt",
                   append=FALSE, col_names = FALSE)
}else{
readr::write_lines(d,
                   file="Relation_P279_P31.nt",
                   append=TRUE, col_names = FALSE)
}

d <- a[grepl(" <http://www.wikidata.org/prop/direct/P31> ", a)]
if(!identical(d, character(0))){
x5 <- x5 + 1
if(x5 == 1){
readr::write_lines(d,
                   file="Relation_P279_P31.nt",
                   append=FALSE, col_names = FALSE)
}else{
readr::write_lines(d,
                   file="Relation_P279_P31.nt",
                   append=TRUE, col_names = FALSE)
}}}}
}

##chebi
if(TypeL == "chebi"){
if(!grepl(".nt$", File_path)){return(message("Warning: Not proper value of File_path"))}
con_file <- file(description = File_path, open = "r")
print(con_file)

#Execution number
x <- 0
x1 <- 0
x2 <- 0

#Rows per read
N <- 100000

#Purse NT file to CSV
while( TRUE ){
x <- x + 1
message(paste0("No: ", formatC(x, width=4, flag="0"), " read lines: ", x*N ))
try(a <- readLines(con_file, n = N), silent=T)
if ( length(a) == 0 ) { close(con_file); break }

##extract English labels
d <- a[grepl(" <http://www.w3.org/2000/01/rdf-schema#label> ", a)]
if(!identical(d, character(0))){
x1 <- x1 + 1
if(x1 == 1){
readr::write_lines(d,
                   file="Label_en_rdfs.nt",
                   append=FALSE, col_names = FALSE)
}else{
readr::write_lines(d,
                   file="Label_en_rdfs.nt",
                   append=TRUE, col_names = FALSE)
}
}

##extract class hierarchy
d <- a[grepl(" <http://www.w3.org/2000/01/rdf-schema#subClassOf> ", a)]
e <- d[!grepl("[>] [_][:]", d)]

if(!identical(e, character(0))){
x2 <- x2 + 1
if(x2 == 1){
readr::write_lines(e,
                   file="Relation_subClassOf.nt",
                   append=FALSE, col_names = FALSE)
}else{
readr::write_lines(e,
                   file="Relation_subClassOf.nt",
                   append=TRUE, col_names = FALSE)
}}}
}

## mesh
if(TypeL == "mesh"){
if(!grepl(".nt$", File_path)){return(message("Warning: Not proper value of File_path"))}
con_file <- file(description = File_path, open = "r")
print(con_file)

#Execution number
x <- 0
x1 <- 0
x2 <- 0

#Rows per read
N <- 100000

#Purse NT file to CSV
while( TRUE ){
x <- x + 1
message(paste0("No: ", formatC(x, width=4, flag="0"), " read lines: ", x*N ))
try(a <- readLines(con_file, n = N), silent=T)
if ( length(a) == 0 ) { close(con_file); break }

##extract English labels
d <- a[grepl("@en [.]", a)]
if(!identical(d, character(0))){
x1 <- x1 + 1
if(x1 == 1){
readr::write_lines(d,
                   file="mesh_Label_en.nt",
                   append=FALSE, col_names = FALSE)
}else{
readr::write_lines(d,
                   file="mesh_Label_en.nt",
                   append=TRUE, col_names = FALSE)
}
}

##extract class hierarchy
d <- a[!grepl("@en [.]", a)]
e <- d[!grepl("@[a-z][a-z]", d)]

if(!identical(e, character(0))){
x2 <- x2 + 1
if(x2 == 1){
readr::write_lines(e,
                   file="mesh_others.nt",
                   append=FALSE, col_names = FALSE)
}else{
readr::write_lines(e,
                   file="mesh_others.nt",
                   append=TRUE, col_names = FALSE)
}}}
}

return( message(paste0("Finished!!")) )

}

