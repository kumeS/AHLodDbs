rm(list=ls())

if(F){
##ファイル変換
#system("cat ./00_Input/wikidata201013_v01_copy/Label_df_rdfslabel.csv ./00_Input/wikidata201013_v01_copy/Label_df_skosaltLabel.csv > ./00_Input/wikidata201013_v01_copy/Label_df_rdfslabel_skosaltLabel.csv")
#system('grep -e "@ja" ./00_Input/wikidata201013_v01_copy/Label_df_rdfslabel_skosaltLabel.csv > ./00_Input/wikidata201013_v01_copy/Label_df_rdfslabel_skosaltLabel_jpn.csv')
}

#file_path <- "./00_Input/wikidata201013_v01_copy/Label_df_rdfslabel_skosaltLabel_nkf_jpn.csv"
#Lin <- strsplit(system(paste0("wc -l ", file_path), intern = T), split = " [.][/]")[[1]][1]
#Lin

#分割
#round(as.numeric(Lin)/30, 0)
#Lin00 <- round(as.numeric(Lin)/30, 0)+1
#getwd()
#system("head ./NEDO_pj/ToDo_210412/00_Input/wikidata201013_v01_copy/Label_df_rdfslabel_skosaltLabel_nkf_jpn.csv")
#system(paste0("split -l ", Lin00, " ./00_Input/wikidata201013_v01_copy/Label_df_rdfslabel_skosaltLabel_nkf_jpn.csv ./00_Input/wikidata201013_v01_copy/Label_df_rdfslabel_skosaltLabel_nkf_jpn.s"))
#ff <- dir("./00_Input/wikidata201013_v01_copy", pattern = "Label_df_rdfslabel_skosaltLabel_nkf_jpn.s", full.names = T)
#for(n in 1:length(ff)){system(paste0("mv ", ff[n], " ", stringr::str_sub(ff[n], start=1, end=nchar(ff[n])-4), "_", formatC(n, width = 2, flag = 0), ".csv"))}

###################################
#実行
#for( n in 1:30 ){system(paste0("Rscript ./R_script_TXT_v01/Pre_R00_TXT_match_v02.R ", n, " &"))}
###################################

args1 = as.numeric(commandArgs(trailingOnly=TRUE)[1])
fff <- dir("./00_Input/wikidata201013_v01_copy", pattern = "Label_df_rdfslabel_skosaltLabel_nkf_jpn_", full.names = T)

#args1 <- 6
#選択
fff0 <- fff[args1]

if(!file.exists("./00_Input")){dir.create("./00_Input")}
#ファイルパス
file_path <- fff0
con_file <- file(description = file_path, open = "r")
con_file
#close(con_file)

#Ex
#for(N in 1:756){readLines(con_file, n = 1, encoding="UTF-8")}

x <- 0
N <- 1

while( TRUE ){
x <- x + 1
print(paste0("No: ", x, " Line: ", x*N ))
try(a <- readLines(con_file, n = N, encoding="UTF-8"), silent=T)
print(paste0("Line: ", a ))
if ( length(a) == 0 ) { close(con_file); break }

#head(a)
a1 <- unlist(strsplit(sub(",", "AiBiCiDiEiFiG", sub(",", "AiBiCiDiEiFiG", a)), split="AiBiCiDiEiFiG"))
if( (length(a1) %% 3) == 0 ){
  b <- matrix(a1, ncol=3, byrow=T)
}else{
  b <- matrix(a1[1:(length(a1) - (length(a1) %% 3))], ncol=3, byrow=T)
}

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

#head(b, n =20)
b1 <- data.frame(b)
b1$X4 <- lang
#head(b1, n =20)

#部分一致検索
AA <- as.character(b1$X3)
suppressWarnings(try(Count <- system(paste("TERMS=$\"", AA, "\" ; grep -o \"$TERMS\" ./00_Input/ALL_extracted_corpus4compounds.csv | grep -c \"$TERMS\"", sep=""), intern=T), silent=T))
if(identical(as.numeric(Count), numeric(0))){
b1$X5 <- 0
}else{
b1$X5 <- as.numeric(Count)
}

print(paste0("Line: ", paste(b1, collapse = ", ") ))

if(nrow(b1) > 0){
if(x == 1){
readr::write_csv(b1, file=paste0("./00_Input/Count_results_", formatC(args1, width = 2, flag = 0), ".csv"), append=F, col_names=F)    
}else{
readr::write_csv(b1, file=paste0("./00_Input/Count_results_", formatC(args1, width = 2, flag = 0), ".csv"), append=T, col_names=F)  
}
}
}

#3000件の部分一致検索、30min
#Read results









