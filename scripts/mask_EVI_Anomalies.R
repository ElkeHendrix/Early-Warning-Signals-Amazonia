# mask EVI anomalies with extremely dry areas (AMCWD anomalies)

library(raster)

REPO_HOME <- paste(getwd(),'/../',sep='')
# load EVI anomalies
path.EVI.anomalies <- paste(REPO_HOME, "data/EVI-Anomalies/AEVI_MIN2016.tif", sep="")
EVI.Anomalies.2016<- raster(path.EVI.anomalies)
plot(EVI.Anomalies.2016)
# load AMCWD anomalies
path.AMCWS.anomalies<- paste(REPO_HOME, "/results/ExposureDataset_2stdev.tif", sep="")
AMCWD.anomalies<- raster("C:/Users/elkeh/Documents/Github_repository_paper/Early-Warning-Signals-Amazonia/results/ExposureDataset_1stdev.tif")
plot(AMCWD.anomalies)

# resample AMCWD.anomalies to EVI anomalies
res.AMCWD<- resample(AMCWD.anomalies, EVI.Anomalies.2016, method= "ngb" )

# resample to the resolution of EWS
mask.Anomalies<-mask(EVI.Anomalies.2016, res.AMCWD, maskvalue=NA)
plot(mask.Anomalies)

writeRaster(mask.Anomalies, "C:/Users/elkeh/Documents/Github_repository_paper/Early-Warning-Signals-Amazonia/results/masked_EVI_Anomalies.tif")