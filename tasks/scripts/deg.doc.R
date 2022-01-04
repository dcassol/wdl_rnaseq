'deg

Usage:
      deg.doc.R [--outputcountDF <file>] [--targets <file>] [--DEGcounts <file>] 

Options:
    --targets <file> Sampple data path.
    --outputcountDF <file> outputcountDF path.
    --DEGcounts <file> DEGcounts data path.
    ' -> doc
suppressPackageStartupMessages({
    library(docopt)
    library(systemPipeR)
    library(DESeq2, quietly=TRUE)
})

opts <- docopt(doc)

countDF <- as.matrix(read.table(opts$outputcountDF))
targets <- read.delim(opts$targets, comment = "#")
cmp <- readComp(file = opts$targets, format = "matrix", delim = "-")

degseqDF <- run_DESeq2(countDF = countDFeByg, targets = targets, cmp = cmp[[1]],
                       independent = FALSE)
DEG_list <- filterDEGs(degDF=degseqDF, filter=c(Fold=2, FDR=20))
write.table(DEG_list$Summary, opts$DEGcounts, quote=FALSE, sep="\t", row.names=FALSE)

print("Step done successfully")


