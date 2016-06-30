act_locs = read.table("../VT/sweden_locations_v3.txt", header=TRUE, comment.char="")
names(act_locs)[names(act_locs)=="X.id"] = "id"

act_locs = act_locs[c("id", "x", "y", "zone", "level0_area_id", "level1_area_id", "level2_area_id", "work", "school", "retail", "other", "religious")] 
act_locs[act_locs==0.0001] = 0
write.table(act_locs, file="../data/act_locs.txt", row.names=FALSE)
