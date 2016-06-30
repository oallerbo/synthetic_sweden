image.with.scale = function(x, y, z, col) {
 par(mar=c(1,1,1,1))
 plot.new()
 par(fig=c(0,0.9,0,1), new=TRUE)
 image(x, y, z, col=r)
 par(fig=c(0.85,0.95,0,1), new=TRUE)

 zlim <- range(z, na.rm=TRUE)
 zlim[2] <- zlim[2]+c(zlim[2]-zlim[1])*(1E-3)#adds a bit to the range in both directions
 zlim[1] <- zlim[1]-c(zlim[2]-zlim[1])*(1E-3)
 breaks <- seq(zlim[1], zlim[2], length.out=(length(col)+1))
 poly <- vector(mode="list", length(col))
 for(i in seq(poly)){
  poly[[i]] <- c(breaks[i], breaks[i+1], breaks[i+1], breaks[i])
 }
 ylim<-range(breaks); 
 xlim<-c(0,1)
 plot(1,1,t="n",ylim=ylim, xlim=xlim, axes=FALSE, xlab="", ylab="", xaxs="i", yaxs="i")  
 for(i in seq(poly)){
  polygon(c(0,0,1,1), poly[[i]], col=col[i], border=NA)
 }
 box()
 axis(4)
}
