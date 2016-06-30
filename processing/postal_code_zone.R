act_locs = read.table("../VT/sweden_locations_v3.txt", header=TRUE, comment.char="")
names(act_locs)[names(act_locs)=="X.id"] = "id"

postal_zone = unique(act_locs[c("postal_code", "zone")])
postal_zone = postal_zone[order(postal_zone$postal_code),]
write.table(postal_zone, file="../data/postal_zone.txt", row.names=FALSE)
