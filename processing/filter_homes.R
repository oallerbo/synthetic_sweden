home_locs = read.table("../VT/sweden_home_locs_v3.txt", header=TRUE, comment.char="")
names(home_locs)[names(home_locs)=="X.id"] = "id"
home_locs = home_locs[c("id", "x", "y", "zone", "level0_area_id", "level1_area_id", "level2_area_id", "hloctype")] 
write.table(home_locs, file="../data/home_locs.txt", row.names=FALSE)
