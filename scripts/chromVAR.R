source("https://bioconductor.org/biocLite.R")
#biocLite("BiocInstaller")
#biocLite("devtools")
#biocLite("GreenleafLab/chromVAR")
#biocLite("motifmatchr")
#biocLite("BSgenome.Hsapiens.UCSC.hg19")
#biocLite("JASPAR2016")
#devtools::install_github("GreenleafLab/chromVARmotifs")
library(chromVAR)
library(chromVARmotifs)
library(motifmatchr)
library(Matrix)
library(SummarizedExperiment)
library("BSgenome.Mmusculus.UCSC.mm10")
library(BSgenome.Hsapiens.UCSC.hg19)
set.seed(2017)
require(ggplot2)

setwd("e:/Soloway/sciATAC")
peakfile <- file.path("20180316_p56_redo/p56.distal.ygi.txt")
barcodes <- read.table("20180316_p56_redo/p56.xgi")
cluster <- read.table("2kb.cluster")

peaks <- getPeaks(peakfile, sort_peaks = TRUE)
#resize(peaks, width = 2000, fix = "center")

cluster <- paste0("c", cluster$V1)
qc_barcodes <- paste0("20180316_p56_redo/cells/", barcodes$V1, ".sorted.nodup.bam")
fragment_counts <- getCounts(qc_barcodes, peaks, paired =  TRUE, by_rg = FALSE, format = "bam", colData = DataFrame(cell = barcodes, cluster = cluster))
fragment_counts

################################################################
#examplecounts
example_counts <- addGCBias(fragment_counts, 
                            genome = BSgenome.Mmusculus.UCSC.mm10)
counts_filtered <- filterSamples(example_counts, min_depth = 1200,
                                 min_in_peaks = 0.15)
counts_filtered <- filterPeaks(example_counts)
motifs <- getJasparMotifs()
motif_ix <- matchMotifs(motifs, counts_filtered,
                        genome = BSgenome.Mmusculus.UCSC.mm10)

# computing deviations
dev <- computeDeviations(object = counts_filtered, 
                         annotations = motif_ix)

variability <- computeVariability(dev)
plotVariability(variability, use_plotly = FALSE)

sample_cor <- getSampleCorrelation(dev)
library(pheatmap)
phtmp <- pheatmap(as.dist(sample_cor), 
                  annotation_row = colData(dev), 
                  clustering_distance_rows = as.dist(1-sample_cor), 
                  clustering_distance_cols = as.dist(1-sample_cor))

tsne_results <- deviationsTsne(dev, threshold = 1.2, perplexity = 30, 
                               shiny = FALSE)
#top variability FOSL1, JUNB, FOSL2
tsne_plots <- plotDeviationsTsne(dev, tsne_results, annotation = "DLX2", 
                                 sample_column = "cluster", shiny = FALSE)
tsne_plots[[1]]
tsne_plots[[2]]

diff_acc <- differentialDeviations(dev, "cluster")
head(diff_acc)

#motif similarity
inv_tsne_results <- deviationsTsne(dev, threshold = 1.0, perplexity = 50, 
                                   what = "annotations", shiny = FALSE)
library(ggplot2)
ggplot(inv_tsne_results, aes(x = Dim1, y = Dim2)) + geom_point() + 
  chromVAR_theme()

#kmer
kmer_ix <- matchKmers(6, counts_filtered, genome = BSgenome.Mmusculus.UCSC.mm10)
kmer_dev <- computeDeviations(counts_filtered, kmer_ix)
kmer_cov <- deviationsCovariability(kmer_dev)
plotKmerMismatch("AAAAAA",kmer_cov)
################################################################


################################################
library(Rtsne)
library(densityClust)

MaxStep <- function(D){
  D_hat <- D
  n = nrow(D)
  for(k in 1:n){
    for(i in 1:(n-1)){
      for(j in (i+1):n){
        D_hat[i,j] <- min(D_hat[i,j], 
                          max(D_hat[k,j], D_hat[i,k]))
      }
    }
  }
  return(D_hat)
}
find_center <- function(p, clust){
  centers <- data.frame()
  cols <- c()
  for(i in as.numeric(names(table(clust)))){
    ind <- which(clust== i)
    if(length(ind) > 10){
      centers <- rbind(centers, colMeans(p[ind,1:3]))
      cols <- c(cols, i)
    }
  }
  res <- cbind(centers, cols)
  colnames(res) <- c("x", "y", "z", "col")
  return(res)
}
DB_index <- function(D, CL){
  cl_uniq <- unique(CL)
  n <- length(cl_uniq)
  d_k <- rep(0, n)
  d_ij <- matrix(0, n, n)
  for(i in 1:n){
    ii <- which(CL == i);
    d_k[i] <- max(MaxStep(D[ii,ii]))
  }
  for(i in 1:(n-1)){
    for(j in (i+1):n){
      ii <- which(CL == i | CL == j)
      d_ij <- max(MaxStep(D[ii,ii]))
    }
  }
  return(min(d_ij)/max(d_k))
}

set.seed(10)
dis <- dist(tsne_results)
irisClust <- densityClust(dis, gaussian=TRUE)

# plot decision graph
#plot(irisClust)

rho_cutoff <- irisClust$dc
delta_cutoff <- 5
irisClust <- findClusters(irisClust, 
                          rho= rho_cutoff, 
                          delta= delta_cutoff)

clusters <- irisClust$cluster

#barcodes <- read.table("20180321_mix_data/merged.xgi")
#clusters[which(apply(barcodes, 1, function(x) any(grepl("our", x))))] <- -clusters[which(apply(barcodes, 1, function(x) any(grepl("our", x))))]
#unique <- !duplicated(clusters)
plot <- plot(tsne_results, col= clusters, pch=clusters, cex=0.7)
unique <- !duplicated(clusters)
text(tsne_results[unique, 1:2], labels = clusters[unique], cex= 0.7, col = "steelblue", pos = 4)

##########################################
# Obtain cluster information from hclust
tree <- phtmp$tree_col
hcluster <- cutree(tree, k = 13)
head(hcluster)
plot(tsne_results, col=hcluster, pch=hcluster, cex=0.7)

write.table(tsne_results, file = "chromVAR.2kb_noPromoter_cluster.distalPeak.tsne", append = FALSE, 
            quote = FALSE, sep = "\t", eol = "\n", 
            na = "NA", dec = ".", row.names = FALSE,
            col.names = FALSE, qmethod = c("escape", "double"),
            fileEncoding = "")
write.table(data.frame(clusters), file = "chromVAR.2kb_noPromoter_cluster.distalPeak.cluster",
            append = FALSE, quote = FALSE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = FALSE, qmethod = c("escape", "double"),
            fileEncoding = "")
write.table(data.frame(hcluster), file = "p56.hclust.cluster",
            append = FALSE, quote = FALSE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = FALSE, qmethod = c("escape", "double"),
            fileEncoding = "")
