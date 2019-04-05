# create RDS valuetable 

library(raster)
library(Rcpp)
library(dplyr)
library(sp)
library(rgdal)

# load in the EWS

NDVI.autocor<- raster("C:/Users/elkeh/Documents/Github_repository_paper/Early-Warning-Signals-Amazonia/data/EWS/Autocor_NDVI.tif")

LST.night.autocor<- raster("C:/Users/elkeh/Documents/Github_repository_paper/Early-Warning-Signals-Amazonia/data/EWS/Autocor_LSTnight.tif")
LST.night.autocor <- resample(LST.night.autocor, NDVI.autocor, method="ngb")
 
LST.day.autocor<- raster("C:/Users/elkeh/Documents/Github_repository_paper/Early-Warning-Signals-Amazonia/data/EWS/Autocor_LSTday.tif")
LST.day.autocor <- resample(LST.day.autocor, NDVI.autocor, method= "ngb") 
 
NDVI.autocor.spat<- raster("C:/Users/elkeh/Documents/Github_repository_paper/Early-Warning-Signals-Amazonia/data/EWS/Moran3x3_NDVI_SpatialTemporal.tif")
  
LST.night.autocor.spat<- raster("C:/Users/elkeh/Documents/Github_repository_paper/Early-Warning-Signals-Amazonia/data/EWS/Moran3x3_LSTnight_SpatialTemporal.tif")
LST.night.autocor.spat <- resample(LST.night.autocor.spat, NDVI.autocor, method="ngb")
 
LST.day.autocor.spat <- raster("C:/Users/elkeh/Documents/Github_repository_paper/Early-Warning-Signals-Amazonia/data/EWS/Moran3x3_LSTday_SpatialTemporal.tif")
LST.day.autocor.spat <- resample(LST.day.autocor.spat, NDVI.autocor, method="ngb")
  
# load in the non temp variables
  
NDVI.non.temp<- raster("C:/Users/elkeh/Documents/Github_repository_paper/Early-Warning-Signals-Amazonia/data/EWS/NontempNDVI_SpatialHeterogenity.tif")

LST.night.non.temp<- raster("C:/Users/elkeh/Documents/Github_repository_paper/Early-Warning-Signals-Amazonia/data/EWS/NontempLSTnight_SpatialHeterogenity.tif")
LST.night.non.temp<- resample(LST.night.non.temp, NDVI.autocor, method="ngb")

LST.day.non.temp <- raster("C:/Users/elkeh/Documents/Github_repository_paper/Early-Warning-Signals-Amazonia/data/EWS/NontempLSTday_SpatialHeterogenity.tif")
LST.day.non.temp <- resample(LST.day.non.temp, NDVI.autocor, method="ngb")


# load validation dataset 
validation<- raster("C:/Users/elkeh/Documents/Github_repository_paper/Early-Warning-Signals-Amazonia/results/masked_EVI_Anomalies.tif")
validation <- resample(validation, NDVI.autocor, method="ngb")

# load ID per gridcel 
ID<- raster("C:/Users/elkeh/Documents/Github_repository_paper/Early-Warning-Signals-Amazonia/data/ID_Join/join_ID.tif")
ID <- resample(ID, NDVI.autocor, method="nbg")


# Brick all the layers

bricktemp<- brick(NDVI.autocor,LST.day.autocor,LST.night.autocor, NDVI.autocor.spat, LST.day.autocor.spat, LST.night.autocor.spat, NDVI.non.temp, LST.day.non.temp, LST.night.non.temp, validation, ID)
names(bricktemp)<- c("AutocorNDVI", "AutocorLSTday", "AutocorLSTnight", "SpatTempAutoNDVI", "SpatTempAutoLSTday", "SpatTempAutoLSTnight", "NonTempSpatNDVI", "NonTempSpatLSTday", "NonTempSpatLSTnight", "Validatiedataset", "ID")

plot(bricktemp)

#######################################################
# create valuetable
# Omit all NA values 
valuetable<- getValues(bricktemp)
valuetable<- na.omit(valuetable)
valuetable<- as.data.frame(valuetable)

#####################################################
# make sure fire no fire is 50/50
#hist(valuetable$Validatiedataset)
#summary(valuetable$Validatiedataset==5)

#sampleValuetable<-valuetable %>% group_by(Validatiedataset)%>%sample_n(size=4031)

#setwd("C:/Users/elkeh/Documents/artikel/Valuetable")

saveRDS(valuetable, file="C:/Users/elkeh/Documents/Github_repository_paper/Early-Warning-Signals-Amazonia/results/rds_valuetables/EVI_Anomalies_2stdev.rds")

