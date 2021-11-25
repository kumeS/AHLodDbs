##' @title Convert labels to CSV or TSV file
##'
##' @param File_path a character vector for a N-triple (NT) file (.nt).
##' @param tsv save as TSV format
##'
##' @description This function convert the NT file from the RDF dump
##' to CSV or TSV file.
##'
##' @return CSV or TSV file
##' @author Satoshi Kume
##' @export ParseNT_Label
##' @importFrom readr write_csv
##' @importFrom readr write_tsv
##'
##' @examples \dontrun{
##' #Not run
##'
##' #rdfs:label
##' File_path <- "./Label_en_rdfs.nt"
##'
##' #Run
##' ParseNT_Label(File_path)
##' DFtsv2Rdata(File_path)
##'
##' }
##'

ParseNT_Label <- function(File_path,
                          tsv=TRUE){
if(!grepl(".nt$", File_path)){return(message("Warning: Not proper value of File_path"))}

Subject=c("http://id.nlm.nih.gov/mesh/2019/", "mesh2019:",
          "http://id.nlm.nih.gov/mesh/2020/", "mesh2020:",
          "http://id.nlm.nih.gov/mesh/2021/", "mesh2021:",
          "http://id.nlm.nih.gov/mesh/", "mesh:",
          "http://purl.obolibrary.org/obo/", "obo:",
          "http://www.geneontology.org/formats/oboInOwl#", "oboInOwl:",
          "http://purl.bioontology.org/ontology/ICD10/", "icd:",
          "http://purl.jp/bio/10/lsd/icd10/", "icd10:",
          "http://purl.jp/bio/10/lsd/term/", "lsdterms:",
          "http://purl.jp/bio/10/lsd/mesh/", "lsdmesh:",
          "http://purl.jp/bio/10/lsd/ontology/201209#", "lsd:",
          "http://purl.jp/bio/10/lsd/pair/", "lsdpair:")
Property=c("http://id.nlm.nih.gov/mesh/vocab#", "meshv:",
           "http://www.w3.org/1999/02/22-rdf-syntax-ns#", "rdf:",
           "http://www.w3.org/2000/01/rdf-schema#", "rdfs:",
           "http://purl.jp/bio/10/lsd/ontology/201209#", "lsd:",
           "http://www.w3.org/2004/02/skos/core#", "skos:",
           "http://xmlns.com/foaf/0.1/", "foaf:",
           "http://www.w3.org/2002/07/owl#", "owl:")

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

#head(b)
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

#table(grepl("obo[:]", d[,1]))
#d[!grepl("obo[:]", d[,1]),]

#Property
message(paste0("Prefix: Property"))
for(n in seq_len(length(Property)/2)){
#n <- 1
cc <- grepl(paste0("^<", Property[2*n-1]), d[,2])
d[cc,2] <- sub(paste0("^<", Property[2*n-1]), Property[2*n], d[cc,2])
d[cc,2] <- sub(">$", "", d[cc,2])
}

#table(d[,2])

#head(d)
#table(d$X2)
#table(grepl("@en", d$X3))

#X4
if(any(grepl("@en", d$X3))){
message( paste0("Proc: Object & others") )
d$X4 <- "BLANK"
cc <- grepl("@en$", d[,3])
d[cc,4] <- "@en"
d[cc,3] <- sub("@en$", "", d[cc,3])
d[cc,3] <- stringr::str_sub(d[cc,3], start = 2, end = -2)
#head(d)
}

#X4
if(any(grepl("XMLSchema", d$X3))){
#head(d)
message( paste0("Proc: XMLSchema & others") )
d$X4 <- "BLANK"

#Parameters
XMLS <- c("<http://www.w3.org/2001/XMLSchema#date>", "xsd:date",
          "<http://www.w3.org/2001/XMLSchema#int>", "xsd:int",
          "<http://www.w3.org/2001/XMLSchema#boolean>", "xsd:boolean",
          "<http://www.w3.org/2001/XMLSchema#integer>", "xsd:integer",
          "<http://www.w3.org/2001/XMLSchema#float>", "xsd:float",
          "<http://www.w3.org/2001/XMLSchema#string>", "xsd:string")
Num <- c(2, -4)

for(n in seq_len(length(XMLS)/2)){
#n <- 1
cc <- grepl(paste0(XMLS[2*n-1], "$"), d[,3])
d[cc,4] <- XMLS[2*n]
d[cc,3] <- sub(XMLS[2*n-1], "", d[cc,3])
d[cc,3] <- stringr::str_sub(d[cc,3], start = Num[1], end = Num[2])
}
}
#head(d)
#table(d[,4])

if(tsv){
message(paste0("Save as TSV"))
readr::write_tsv(d,
                 file=paste0(sub(".nt$", "", File_path), "_df.tsv"),
                 append=FALSE, col_names = FALSE, na = "")
}else{
message(paste0("Save as CSV"))
readr::write_csv(d,
                 file=paste0(sub(".nt$", "", File_path), "_df.csv"),
                 append=FALSE, col_names = FALSE, na = "")
}

return( message(paste0("Finished!!")) )

}
