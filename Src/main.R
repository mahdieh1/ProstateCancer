
## Load all dependencies ##
if("data.table" %in% rownames(installed.packages()) == FALSE) {
  
  print("install [data.table]")
  install.packages("data.table")
  
}

if("dbscan" %in% rownames(installed.packages()) == FALSE) {
  
  print("install [dbscan]")
  install.packages("dbscan")
  
}


intersect <- read.table("intersect-gain.bed",header = FALSE, sep="\t",stringsAsFactors=FALSE, quote="")
significant <- read.table("sig-gain.txt",header = FALSE, sep="\t",stringsAsFactors=FALSE, quote="")
Number <- read.table("NO-gain.txt",header = TRUE, sep="\t",stringsAsFactors=FALSE, quote="")

CNVRsSelection(df = intersect ,cnv = significant ,NO = Number ) 
