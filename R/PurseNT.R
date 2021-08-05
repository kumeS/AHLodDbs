##' @title Convert the triples  to the CSV file
##'
##' @param File_path a character vector,
##' indicating a N-triple (NT) file path (.nt).
##'
##' @description This function use the NT file and
##' convert from the small dump dataset (less than nearly 2GB) to CSV file.
##'
##' @return CSV file
##' @author Satoshi Kume
##' @export PurseNT
##' @importFrom readr write_csv
##' @importFrom readr read_lines
##'
##' @examples \dontrun{
##'
##' #Class hierarchy
##' File_path <- "./mesh2019_others2.nt"
##'
##' # Run
##' PurseNT(File_path)
##' DFcsv2Rdata(File_path)
##'
##' }
##'

PurseNT <- function(File_path){

if(!grepl(".nt$", File_path)){return(message("Warning: Not proper value of File_path"))}

Subject=c("http://id.nlm.nih.gov/mesh/2019/", "mesh2019:",
          "http://id.nlm.nih.gov/mesh/2020/", "mesh2020:",
          "http://id.nlm.nih.gov/mesh/2021/", "mesh2021:",
          "http://id.nlm.nih.gov/mesh/", "mesh:",
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
Object=c("http://id.nlm.nih.gov/mesh/2019/", "mesh2019:",
         "http://id.nlm.nih.gov/mesh/2020/", "mesh2020:",
         "http://id.nlm.nih.gov/mesh/2021/", "mesh2021:",
         "http://id.nlm.nih.gov/mesh/", "mesh:",
         "http://id.nlm.nih.gov/mesh/vocab#", "meshv:",
         "http://purl.bioontology.org/ontology/ICD10/", "icd:",
         "http://purl.jp/bio/10/lsd/term/", "lsdterms:",
         "http://purl.jp/bio/10/lsd/mesh/", "lsdmesh:",
         "http://purl.jp/bio/10/lsd/ontology/201209#", "lsd:",
         "https://lsd-project.jp/weblsd/tree/", "weblsdweblsd:")
Lang = c("@en", "@ja", "@ja-Hrkt")

message(paste0("Read data"))
a <- readr::read_lines(File_path, progress = FALSE)

#Remove the first line
a <- a[!grepl("^# <http://id.nlm.nih.gov/mesh>", a)]
#head(a)

####################################################################
####################################################################
message(paste0("convert tab symbol to space"))
if(any(grepl(">\t", a))){
a <- sub(">\t", "> ", a)
a <- sub(">\t", "> ", a)
}

message(paste0("Split data"))
#AiBiCiDiEiFiG: Unique arbitrary string
a1 <- unlist(strsplit(sub(" ", "AiBiCiDiEiFiG", sub(" ", "AiBiCiDiEiFiG", a)), split="AiBiCiDiEiFiG"))
if((length(a1) %% 3) == 0){
  b <- matrix(a1, ncol=3, byrow=T)
}else{
  b <- matrix(a1[1:(length(a1) - (length(a1) %% 3))], ncol=3, byrow=T)
}

message(paste0("Remove [.]$"))
b[,3] <- sub(" [.]$", "", b[,3])

#head(b); dim(b)
message(paste0("Convert matrix to DF"))
d <- data.frame(b)
####################################################################
####################################################################
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

#Object
message(paste0("Prefix: Object"))
for(n in seq_len(length(Object)/2)){
#n <- 1
cc <- grepl(paste0("^<", Object[2*n-1]), d[,3])
d[cc,3] <- sub(paste0("^<", Object[2*n-1]), Object[2*n], d[cc,3])
d[cc,3] <- sub(">$", "", d[cc,3])
}

#head(d, n=1000)
#tail(d, n=1000)
#table(d$X1)
#table(d$X2)
#table(d$X3)

####################################################################
####################################################################
#X4
message( paste0("Proc: XMLSchema & others") )
d$X4 <- "BLANK"

#Parameters
XMLS <- c("<http://www.w3.org/2001/XMLSchema#date>", "xsd:date",
          "<http://www.w3.org/2001/XMLSchema#int>", "xsd:int",
          "<http://www.w3.org/2001/XMLSchema#boolean>", "xsd:boolean",
          "<http://www.w3.org/2001/XMLSchema#integer>", "xsd:integer",
          "<http://www.w3.org/2001/XMLSchema#float>", "xsd:float")
Num <- c(2, -4)

for(n in seq_len(length(XMLS)/2)){
#n <- 1
cc <- grepl(paste0(XMLS[2*n-1], "$"), d[,3])
d[cc,4] <- XMLS[2*n]
d[cc,3] <- sub(XMLS[2*n-1], "", d[cc,3])
d[cc,3] <- stringr::str_sub(d[cc,3], start = Num[1], end = Num[2])
}
#head(d[cc,])

#Mesh
cc <- grepl("meshv:identifier", d[,2]) & !grepl("meshv:TreeNumber", d[,3])
d[cc,3] <- stringr::str_sub(d[cc,3], start = 2, end = -2)
cc <- grepl("meshv:registryNumber", d[,2])
d[cc,3] <- stringr::str_sub(d[cc,3], start = 2, end = -2)
#head(d[cc,])

#X4
message( paste0("Proc: Object & others") )
for(m in seq_len(length(Lang))){
#m <- 1
cc <- grepl(paste0(Lang[m], "$"), d[,3])
d[cc,4] <- Lang[m]
d[cc,3] <- sub(paste0(Lang[m], "$"), "", d[cc,3])
d[cc,3] <- stringr::str_sub(d[cc,3], start = 2, end = -2)
}
#head(d[cc,])

####################################################################
####################################################################
message(paste0("Proc: relatedRegistryNumber"))

cc <- grepl("meshv:relatedRegistryNumber", d[,2])
#head(d[cc,]); table(cc)
d[cc,3] <- stringr::str_sub(d[cc,3], start = 2, end = -2)
#head(d[cc,], n=100)
cc <- grepl("meshv:relatedRegistryNumber", d[,2]) & !grepl("^EC ", d[,3])
#head(d[cc,], n=100)
d2 <- strsplit(sub(" ", "AiBiCiDiEiFiG", d[cc,3]), split="AiBiCiDiEiFiG")
#head(d2, n=20)

if(!identical(d2, list())){
d3 <- c()
for(k in seq_len(length(d2))){
 #k <- 1
  if(length(d2[[k]]) == 2){
  d3 <- rbind(d3, d2[[k]])
  }else{
  d3 <- rbind(d3, c(d2[[k]], "BLANK"))
  }
}

#head(d3)
d4 <- data.frame(d3)
d4$X2 <- sub("^[(]", "", d4$X2)
d4$X2 <- sub("[)]$", "", d4$X2)
#head(d4)
d[cc,c(3:4)] <- d4
#head(d)
}

####################################################################
message(paste0("Save as CSV"))
readr::write_csv(d,
                 file=paste0(sub(".nt$", "", File_path), "_df.csv"),
                 append=FALSE, col_names = FALSE, na = "")
message(paste0("Finished!!"))
####################################################################

}
