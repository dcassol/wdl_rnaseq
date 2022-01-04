'quantification

Usage:
      quantification.doc.R [--gff <file>] [--dataSource <string>] [--db_path <string>] [--outputBam <file>] [--outputcountDF <file>] [--outputrpkm <file>]

Options:
    --gff <file> Annotation file path.
    --dataSource <string> Annotation data source.
    --db_path <file> Annotation data source.
    --outputBam <file> outputBam path.
    --outputcountDF <file> outputcountDF path.
    --outputrpkm <file> outputrpkm path.
    ' -> doc
suppressPackageStartupMessages({
    library(docopt)
    library(systemPipeR)
    library("GenomicFeatures")
    library(BiocParallel)
})

opts <- docopt(doc)

## Prepare the db
txdb <- makeTxDbFromGFF(file=opts$gff, format="gff", dataSource=opts$dataSource, organism="Arabidopsis thaliana")
saveDb(txdb, file=opts$db_path)

outpaths <- read.delim(opts$outputBam, header = FALSE)
# outpaths <- read.delim("results/write_lines_f5141feb12826f869b5516101330b8db.tmp", header = FALSE)
outpaths <- outpaths[[1]]
names(outpaths) <- sapply(outpaths, function(x)systemPipeR:::.getFileName(x))
print(outpaths)
eByg <- exonsBy(txdb, by=c("gene"))
bfl <- BamFileList(outpaths, yieldSize=50000, index=character())
multicoreParam <- MulticoreParam(workers=2); register(multicoreParam); registered()
counteByg <- bplapply(bfl, function(x) summarizeOverlaps(eByg, x, mode="Union", 
                                                         ignore.strand=TRUE, 
                                                         inter.feature=FALSE, 
                                                         singleEnd=TRUE)) 
countDFeByg <- sapply(seq(along=counteByg), function(x) assays(counteByg[[x]])$counts)
rownames(countDFeByg) <- names(rowRanges(counteByg[[1]])); colnames(countDFeByg) <- names(bfl)
rpkmDFeByg <- apply(countDFeByg, 2, function(x) returnRPKM(counts=x, ranges=eByg))
write.table(countDFeByg, opts$outputcountDF, col.names=NA, quote=FALSE, sep="\t")
write.table(rpkmDFeByg, opts$outputrpkm, col.names=NA, quote=FALSE, sep="\t")

print("Step done successfully")