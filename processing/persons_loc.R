persons = read.table("../VT/sweden_person_v3.txt", header=TRUE, comment.char="")
names(persons)[names(persons)=="X.hid"] = "hid"
home_locs = read.table("../data/home_locs.txt", header=TRUE)
home_locs = home_locs[c("id", "x", "y")] 
person_locs = merge(persons, home_locs, by.x="hid", by.y="id")
write.table(person_locs, file="../data/person_locs.txt", row.names=FALSE)
