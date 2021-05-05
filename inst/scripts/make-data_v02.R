library(magrittr)

PurseNT_ClassHierarchy <- function(File_path){
con_file <- file(description = File_path, open = "r")
print(con_file)
#close(con_file)

#Execution number
x <- 0
#Rows per read
N <- 100000

#Purse NT file to CSV
while( TRUE ){
x <- x + 1
print(paste0("No: ", x, " Line: ", x*N ))
try(a <- readLines(con_file, n = N), silent=T)
if ( length(a) == 0 ) { close(con_file); break }
#head(a)
#AiBiCiDiEiFiG: Unique arbitrary string
a1 <- unlist(strsplit(sub(" ", "AiBiCiDiEiFiG", sub(" ", "AiBiCiDiEiFiG", a)), split="AiBiCiDiEiFiG"))
if( (length(a1) %% 3) == 0 ){
  b <- matrix(a1, ncol=3, byrow=T)
}else{
  b <- matrix(a1[1:(length(a1) - (length(a1) %% 3))], ncol=3, byrow=T)
}

#head(b)
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

#head(b)
#dim(b)

#convert matrix to DF
d <- data.frame(b)

if(x == 1){
readr::write_csv(d,
                 file=paste0(sub(".nt", "", File_path), "_df.csv"),
                 append=FALSE, col_names = FALSE)
}else{
readr::write_csv(d,
                 file=paste0(sub(".nt", "", File_path), "_df.csv"),
                 append=TRUE, col_names = FALSE)
}}
#close(con_file)
}

############################################################
############################################################
PurseNT_Label <- function(File_path){
con_file <- file(description = File_path, open = "r")
print(con_file)
#close(con_file)

#Execution number
x <- 0
#Rows per read
N <- 100000

while( TRUE ){
x <- x + 1
print(paste0("No: ", x, " Line: ", x*N ))
try(a <- readLines(con_file, n = N), silent=T)
if ( length(a) == 0 ) { close(con_file); break }

#head(a)
a1 <- unlist(strsplit(sub(" ", "AiBiCiDiEiFiG", sub(" ", "AiBiCiDiEiFiG", a)), split="AiBiCiDiEiFiG"))
if( (length(a1) %% 3) == 0 ){
  b <- matrix(a1, ncol=3, byrow=T)
}else{
  b <- matrix(a1[1:(length(a1) - (length(a1) %% 3))], ncol=3, byrow=T)
}

#head(b)
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

#Object
##どう書くか？？



#head(b)
#dim(b)
#convert matrix to DF
d <- data.frame(b)

if(x == 1){
readr::write_csv(d,
                 file=paste0(sub(".nt", "", File_path), "_df.csv"),
                 append=FALSE, col_names = FALSE)
}else{
readr::write_csv(d,
                 file=paste0(sub(".nt", "", File_path), "_df.csv"),
                 append=TRUE, col_names = FALSE)
}}
#close(con_file)
}


############################################################
############################################################
PurseNT_Others <- function(File_path){
con_file <- file(description = File_path, open = "r")
print(con_file)
#close(con_file)

#Execution number
x <- 0
#Rows per read
N <- 100000

#Purse NT file to CSV
while( TRUE ){
x <- x + 1
print(paste0("No: ", x, " Line: ", x*N ))
try(a <- readLines(con_file, n = N), silent=T)
if ( length(a) == 0 ) { close(con_file); break }
#head(a)
#AiBiCiDiEiFiG: Unique arbitrary string
a1 <- unlist(strsplit(sub(" ", "AiBiCiDiEiFiG", sub(" ", "AiBiCiDiEiFiG", a)), split="AiBiCiDiEiFiG"))
if( (length(a1) %% 3) == 0 ){
  b <- matrix(a1, ncol=3, byrow=T)
}else{
  b <- matrix(a1[1:(length(a1) - (length(a1) %% 3))], ncol=3, byrow=T)
}

#head(b)
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
cc <- grepl("^\"", b[,3])
b[cc,3] <- sub("^\"", "", b[cc,3])
cc <- grepl("\"$", b[,3])
b[cc,3] <- sub("\"$", "", b[cc,3])
#table(cc)
#head(b)
#dim(b)

#convert matrix to DF
d <- data.frame(b)

if(x == 1){
readr::write_csv(d,
                 file=paste0(sub(".nt", "", File_path), "_df.csv"),
                 append=FALSE, col_names = FALSE)
}else{
readr::write_csv(d,
                 file=paste0(sub(".nt", "", File_path), "_df.csv"),
                 append=TRUE, col_names = FALSE)
}}
#close(con_file)
}

############################################################
############################################################
PurseNT_Prop <- function(File_path){
con_file <- file(description = File_path, open = "r")
print(con_file)
#close(con_file)

#Execution number
x <- 0
#Rows per read
N <- 100000

#Purse NT file to CSV
while( TRUE ){
x <- x + 1
print(paste0("No: ", x, " Line: ", x*N ))
try(a <- readLines(con_file, n = N), silent=T)
if ( length(a) == 0 ) { close(con_file); break }
#head(a)
#AiBiCiDiEiFiG: Unique arbitrary string
a1 <- unlist(strsplit(sub(" ", "AiBiCiDiEiFiG", sub(" ", "AiBiCiDiEiFiG", a)), split="AiBiCiDiEiFiG"))
if( (length(a1) %% 3) == 0 ){
  b <- matrix(a1, ncol=3, byrow=T)
}else{
  b <- matrix(a1[1:(length(a1) - (length(a1) %% 3))], ncol=3, byrow=T)
}

#head(b); tail(b)
# remove [.]
b[,3] <- sub(" [.]$", "", b[,3])

#Subject
cc <- grepl("^<http://www.wikidata.org/prop/direct/P[0-9]", b[,1])
b[cc,1] <- sub("^<http://www.wikidata.org/prop/direct/", "wdt:", b[cc,1])
b[cc,1] <- sub(">$", "", b[cc,1])
cc <- grepl("^<http://www.wikidata.org/entity/P[0-9]", b[,1])
b[cc,1] <- sub("^<http://www.wikidata.org/entity/", "wd:", b[cc,1])
b[cc,1] <- sub(">$", "", b[cc,1])

#Property
for(n in 1:ncol(Prefix)){
cc <- grepl(paste0("^", Prefix[2,n]), b[,2])
b[cc,2] <- sub(paste0("^", Prefix[2,n]), paste0(Prefix[1,n]), b[cc,2])
b[cc,2] <- sub(paste0(Prefix[3,n], "$"), "", b[cc,2])
}

#Object
cc <- grepl("^<http://www.wikidata.org/prop/direct/P[0-9]", b[,3])
b[cc,3] <- sub("^<http://www.wikidata.org/prop/direct/", "wdt:", b[cc,3])
b[cc,3] <- sub(">$", "", b[cc,3])
cc <- grepl("^<http://www.wikidata.org/entity/Q[0-9]", b[,3])
b[cc,3] <- sub("^<http://www.wikidata.org/entity/", "wd:", b[cc,3])
b[cc,3] <- sub(">$", "", b[cc,3])
cc <- grepl("^<http://www.wikidata.org/entity/P[0-9]", b[,3])
b[cc,3] <- sub("^<http://www.wikidata.org/entity/", "wd:", b[cc,3])
b[cc,3] <- sub(">$", "", b[cc,3])
cc <- !grepl("<http://www.w3.org/2001/XMLSchema#decimal>$", b[,3])
b <- b[cc,]

#convert matrix to DF
d <- data.frame(b)

if(x == 1){
readr::write_csv(d,
                 file=paste0(sub(".nt", "", File_path), "_df.csv"),
                 append=FALSE, col_names = FALSE)
}else{
readr::write_csv(d,
                 file=paste0(sub(".nt", "", File_path), "_df.csv"),
                 append=TRUE, col_names = FALSE)
}}
#close(con_file)
}

############################################################
############################################################
DFcsv2Rdata <- function(File_path){
if(any(dir() == sub("^./", "", paste0(sub(".nt", "", File_path), "_df.Rdata")))){file.remove(paste0(sub(".nt", "", File_path), "_df.Rdata"))}
Dat <- data.frame(readr::read_csv(paste0(sub(".nt", "", File_path), "_df.csv"), col_names = FALSE))

Dat %>%
  head() %>%
  knitr::kable(format = "pipe", booktabs = T, align = "c") %>%
  print()

message(paste0('dim(Dat): ', paste0(dim(Dat), collapse = " ")))
message(paste0('sum(grepl("^wd:", Dat[,1])): ', sum(grepl("^wd:", Dat[,1]))))
message(paste0('sum(grepl("^wdt:", Dat[,2])): ', sum(grepl("^wdt:", Dat[,2]))))
message(paste0('sum(grepl("^wd:", Dat[,3])): ', sum(grepl("^wd:", Dat[,3]))))

saveRDS(Dat, file = paste0(sub(".nt", "", File_path), "_df.Rdata"))

}



Prefix <- data.frame(wd=c("wd:", "<http://www.wikidata.org/entity/", ">"),
                     wdt=c("wdt:", "<http://www.wikidata.org/prop/direct/", ">"),
                     wikibase=c("wikibase:", "<http://wikiba.se/ontology#", ">"),
                     rdf=c("rdf:", "<http://www.w3.org/1999/02/22-rdf-syntax-ns#", ">"),
                     wdtn=c("wdtn:", "<http://www.wikidata.org/prop/direct-normalized/", ">"))







