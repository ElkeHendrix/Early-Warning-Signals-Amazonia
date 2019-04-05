# Calculate AMCWD anomalies 
library(raster)
library(spatialEco)

REPO_HOME <- paste(getwd(),'/../',sep='')

## stack all the minimum water deficits per year
path.name<- paste(REPO_HOME, '/data/AMCWD1981-2017', sep='')
Min_WD<-stack(list.files(path = path.name))

# drop year 2017
Min_wD_till2016<- dropLayer(Min_WD, 37)

## calculate mean water deficit 
mean<-calc(Min_wD_till2016, fun=mean)
plot(mean)
mean<- calc(Min_wD_till2016, fun=mean)

# calculate standard deviation
stdev<-calc(Min_wD_till2016, fun=sd)
plot(stdev)

## select layer 2015, 2016
mean2015_2016<-dropLayer(Min_wD_till2016, 1:34)
plot(mean2015_2016)

## use the minimum water deficit values in 2015 and 2016 combined 
min_wD2015_2016<-calc(mean2015_2016, fun=min)
plot(min_wD2015_2016)

## Calculate the AMCWD
AMCWD<- (min_wD2015_2016 - mean) 
plot(AMCWD)

AMCWD_st<- AMCWD / stdev
plot(AMCWD_st)

## now calculate the p value --> gebruik hier een p value van 0.1 anders te weinig data over
## https://planetcalc.com/7803/
probeersel<-AMCWD_st
probeersel[probeersel>-1]<-NA
plot(probeersel)

probeersel[probeersel< -1]<-10
plot(probeersel)

writeRaster(probeersel, "ExposureDataset_1stdev.tif", overwrite=TRUE)

## resample
rasterRes<-raster("C:/Users/elkeh/Documents/PogingTotBackUp/EWMRandomTime/AutocorLSTday_NON_Random.tif")
plot(rasterRes)

ResAMCWD<- probeersel
ResAMCWD[ResAMCWD< -1]<- 3
plot(ResAMCWD)

setwd("C:/Users/elkeh/Documents/artikel/Validatiedataset")
writeRaster(ResAMCWD, "ExposureDataset_2stdev.tif")

