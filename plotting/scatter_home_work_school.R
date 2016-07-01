
acts = read.table("../data/act_locs.txt", header=TRUE)
works = acts[acts$work==1,]
schools = acts[acts$school==1,]
hh = read.table("../data/home_locs.txt", header=TRUE)
hh$col = hh$hloctype
hh$col[hh$col==9]=3
hh$col[hh$col==49]=4
hh$col = hh$col + 1
#colors: (1: black,) 2: red, 3: green, 4: blue, 5: cyan, (6: magenta, 7: yellow, 8: gray)

#För att plotta OSM-karta. Men jag vet ännu inte hur man lägger en scatter plot på kartan.
#library(OpenStreetMap)
#library(rgdal)
# map <- openmap(c(57.85,11.7), c(57.55,12.2))
#plot(map)

#Gothenburg
works_got = works[works$zone==20298983,]
schools_got = schools[schools$zone==20298983,]
hh_got = hh[hh$zone==20298983,]


pdf("../plots/households_got.pdf")
plot(hh_got$x, hh_got$y, pch=15, cex=0.02, col=hh_got$col)
dev.off()

pdf("../plots/works_got.pdf")
plot(works_got$x, works_got$y, pch=15, cex=0.02)
dev.off()

pdf("../plots/schools_got.pdf")
plot(schools_got$x, schools_got$y, pch=15, cex=0.02)
dev.off()


#Southern Sweden
works_south = works[works$y<59,]
schools_south = schools[schools$y<59,]
hh_south = hh[hh$y<59,]

pdf("../plots/households_south.pdf")
plot(hh_south$x, hh_south$y, pch=15, cex=0.001, col=hh_south$col)
dev.off()

pdf("../plots/works_south.pdf")
plot(works_south$x, works_south$y, pch=15, cex=0.001)
dev.off()

pdf("../plots/schools_south.pdf")
plot(schools_south$x, schools_south$y, pch=15, cex=0.001)
dev.off()
