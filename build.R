#libs
library(pacman)
p_load(devtools, roxygen2)

#make documentation
try({setwd("./USA.county.data")}, silent = T) #if this fails, it probably means we are already in the right dir
document()

#install
setwd("..")
install("USA.county.data")

#load
library(USA.county.data)
