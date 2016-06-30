home_locs = read.table("../data/home_locs.txt", header=TRUE)
act_locs = read.table("../data/act_locs.txt", header=TRUE)

home_locs$work = NA
home_locs$school = NA
home_locs$retail = NA
home_locs$other = NA
home_locs$religious = NA
act_locs$hloctype = NA
all_locs = rbind(home_locs, act_locs)
write.table(all_locs, file="../data/all_locs.txt", row.names=FALSE)
