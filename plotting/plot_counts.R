source("functions.R")

hh = read.table("../data/home_locs.txt", header=TRUE)
acts = read.table("../data/act_locs.txt", header=TRUE)

library(RColorBrewer)
rf <- colorRampPalette(rev(brewer.pal(11,'Spectral')))
r <- rf(32)

nbins <- 1000
x.bin <- seq(floor(min(hh$x)), ceiling(max(hh$x)), length=nbins)
y.bin <- seq(floor(min(hh$y)), ceiling(max(hh$y)), length=nbins)

freq <-  as.data.frame(table(findInterval(hh$x, x.bin),findInterval(hh$y, y.bin)))
freq[,1] <- as.numeric(freq[,1])
freq[,2] <- as.numeric(freq[,2])

freq2D <- diag(nbins)*0
freq2D[cbind(freq[,1], freq[,2])] <- freq[,3]
freq2D[freq2D == 0] = NA

pdf("../plots/household_counts.pdf")
image.with.scale(x.bin, y.bin, freq2D, col=r)
dev.off()

nbins <- 500
for (act in names(acts)[8:12])
{
  curr_act = acts[acts[[act]]==1,]
  x.bin <- seq(floor(min(curr_act$x)), ceiling(max(curr_act$x)), length=nbins)
  y.bin <- seq(floor(min(curr_act$y)), ceiling(max(curr_act$y)), length=nbins)
  
  freq <-  as.data.frame(table(findInterval(curr_act$x, x.bin),findInterval(curr_act$y, y.bin)))
  freq[,1] <- as.numeric(freq[,1])
  freq[,2] <- as.numeric(freq[,2])
  
  freq2D <- diag(nbins)*0
  freq2D[cbind(freq[,1], freq[,2])] <- freq[,3]
  freq2D[freq2D == 0] = NA

  pdf(paste("../plots/", act, "_counts.pdf", sep=""))
  image.with.scale(x.bin, y.bin, freq2D, col=r)
  dev.off()
}
