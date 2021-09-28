######################################################
## Same processing for all files
######################################################
setwd("./AHLodDbs_02_Dataset_v01/NEDOpj")
getwd(); dir()

######################################################
##For Relation_P279_P31.nt
######################################################
library(AHLodDbs)
File_path <- "./NEDOpj_1_1.nt"
Wikidata_PurseNT_ClassHierarchy(File_path)
DFcsv2Rds(File_path, Type = "wikidata")

#che
a <- readr::read_csv("./NEDOpj_1_1_df.csv", col_names = F)
head(a, n=100)
table(grepl("wd:", a$X1))
table(grepl("wdt:", a$X2))
table(grepl("wd:", a$X3))

a <- readRDS("./NEDOpj_1_1_df.Rds")
head(a, n=100)
table(grepl("wd:", a$Subject))
table(grepl("wdt:", a$Property))
table(grepl("wd:", a$Object))

######################################################
##For Labels
######################################################
setwd("./AHLodDbs_02_Dataset_v01/NEDOpj")

#rdfs:label
File_path <- "./WikidataRDF-10-Apr-2021/Label_en_rdfs.nt"
PurseNT_Label(File_path)
DFcsv2Rdata(File_path)

#主語の略語
WikiLab$Subject <- paste0("wd:", WikiLab$Subject)
head(WikiLab)

#create Lang column
WikiLab$Lang <- stringr::str_sub(WikiLab$Object, start=-3, end=-1)
#head(WikiLab)

#remove \\
Object <- stringr::str_sub(WikiLab$Object, start=1, end=-4)
#head(Object)
Object <- sub("\\\\", "", Object)
Object <- sub("\\\\", "", Object)
Object <- sub("\\\\", "", Object)
Object <- sub("\\\\", "", Object)

head(Object)
WikiLab$Object <- Object
head(WikiLab)

saveRDS(WikiLab, "./WikiLabels.Rds")
readr::write_csv(WikiLab,
                 file="WikiLabels_df.csv",
                 append=FALSE, col_names = FALSE)

a <- readRDS("./WikiLabels.Rds")
head(a)
