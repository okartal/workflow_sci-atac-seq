setwd("Soloway/sciATAC/")
##################################################################
# 1) reads per barcode >= 1000
# 2) consecutive promoter coverage > 3%
# 3) reads in peak ratio >= 20%
# NOTE: The cutoff can vary singificantly between different samples
# 4) filter potential doublets (OPTIONAL NOT SUGGUESTED, UNSTABLE)
##################################################################
setwd("20180316_p56_redo/")

consecutive_promoters <- read.table("mm10_consecutive_promoters.bed")
num_of_reads = read.table("p56.rep1.reads_per_cell")
promoter_cov = read.table("p56.rep1.promoter_cov")
read_in_peak = read.table("p56.rep1.reads_in_peak")
qc = num_of_reads; 
colnames(qc) <- c("barcode", "num_of_reads")
qc$promoter_cov = 0; 
qc$read_in_peak = 0;
qc$promoter_cov[match(promoter_cov$V1, qc$barcode)] = promoter_cov$V2/nrow(consecutive_promoters)
qc$read_in_peak[match(read_in_peak$V1, qc$barcode)] = read_in_peak$V2
qc$ratio = qc$read_in_peak/qc$num_of_reads
idx <- which(qc$promoter_cov > 0.06 & qc$ratio > 0.2 & qc$num_of_reads > 400)
qc_sel <- qc[idx,]

# among these cells, further filter PUTATIVE DOUBLETS ((OPTIONAL NOT SUGGUESTED, UNSTABLE))
#pvalues <- sapply(qc_sel$num_of_reads, function(x) 
#           poisson.test(x, mean(qc_sel$num_of_reads), 
#           alternative="greater")$p.value)
#fdrs <- p.adjust(pvalues, "BH")
#idx <- which(fdrs < 1e-2)

write.table(qc_sel[,1], file = "ATAC.xgi", append = FALSE, 
            quote = FALSE, sep = "\t", eol = "\n", 
            na = "NA", dec = ".", row.names = FALSE,
            col.names = FALSE, qmethod = c("escape", "double"),
            fileEncoding = "")

# Feature Selection
##################################################################
# 1) Filter top 5% peaks
# 2) Filter promoters
# 3) extend and merge
##################################################################
library(GenomicRanges)
peaks.df <- read.table("../p56.rep1_peaks.narrowPeak")
# remove top 5% peaks
cutoff <- quantile((peaks.df$V5), probs = 0.95)
peaks.df <- peaks.df[which(peaks.df$V5 < cutoff),]
proms.df <- read.table("../mm10.refSeq_promoter.bed")

peaks.gr <- GRanges(peaks.df[,1], IRanges(peaks.df[,2], peaks.df[,3]))
proms.gr <- GRanges(proms.df[,1], IRanges(proms.df[,2], proms.df[,3]))

peaks.sel.gr <- peaks.gr[-queryHits(findOverlaps(peaks.gr, proms.gr))]
peaks.sel.ex.gr <- resize(reduce(resize(peaks.sel.gr, 1000, 
                                        fix="center")), 1000, fix="center")

peaks.sel.ex.df <- as.data.frame(peaks.sel.ex.gr)[,1:3]
write.table(peaks.sel.ex.df, file = "p56.rep1.ygi", 
            append = FALSE, quote = FALSE, sep = "\t", 
            eol = "\n", na = "NA", dec = ".", 
            row.names = FALSE, col.names = FALSE, 
            qmethod = c("escape", "double"),
            fileEncoding = "")
