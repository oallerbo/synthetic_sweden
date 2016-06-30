source("functions.R")
pers = read.table("../data/person_locs.txt", header=TRUE)
pers$tporgwk[pers$tporgwk > 10 | pers$tporgwk < 0] = NA
pers$iscoco[pers$iscoco > 10000 | pers$iscoco < 0] = NA
pers$hlthmp[pers$hlthmp < 0] = NA
pers$edlvdse[pers$edlvdse > 100 | pers$edlvdse < 0] = NA
pers$income[pers$income < 0] = NA

library(RColorBrewer)
rf <- colorRampPalette(rev(brewer.pal(11,'Spectral')))
r <- rf(32)

nbins <- 500
x.bin = seq(floor(min(pers$x)), ceiling(max(pers$x)), length=nbins)
y.bin = seq(floor(min(pers$y)), ceiling(max(pers$y)), length=nbins)
pers$xbinned = x.bin[findInterval(pers$x, x.bin)]
pers$ybinned = y.bin[findInterval(pers$y, y.bin)]
temp = as.data.frame(matrix(NA,length(x.bin), length(names(pers))))
names(temp) = names(pers)
temp$xbinned = x.bin
temp$ybinned = y.bin
pers_ext=rbind(pers, temp)

for (attr in names(pers_ext)[3:10])
{
  print(attr)
  means = aggregate(as.formula(paste(attr, "~ xbinned + ybinned")), data=pers_ext, mean, drop=FALSE, na.action=na.pass, na.rm=TRUE)
  mean_mat = matrix(means[[attr]], nrow=length(y.bin), ncol=length(x.bin)) 
  pdf(paste("../plots/", attr, "_means.pdf", sep=""))
  image.with.scale(x.bin, y.bin, mean_mat, col=r)
  dev.off()
}
