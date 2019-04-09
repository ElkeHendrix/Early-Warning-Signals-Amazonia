# plot Hexbinplots for image 1 of paper

library(raster)
library(hexbin)
library(openair)
library(outliers)
library(ggplot2)

# we plot EVI anomalies vs EWS 
autocorVOD<-raster("C:/Users/elkeh/Documents/artikel/NDVI/Autocor_NDVI.tif")
plot(autocorVOD)

autocorLSTday<-raster("C:/Users/elkeh/Documents/artikel/LST/LSTday/Autocor_LSTday.tif")
autocorLSTday<-resample(autocorLSTday, autocorVOD, method="ngb")
plot(autocorLSTday)

autocorLSTnight<-raster("C:/Users/elkeh/Documents/artikel/LST/LSTday/Autocor_LSTnight.tif")
autocorLSTnight<-resample(autocorLSTnight, autocorVOD, method="ngb")
plot(autocorLSTnight)

spatialtempautocorVOD<-raster("C:/Users/elkeh/Documents/artikel/NDVI/Moran3x3_NDVI_SpatialTemporal.tif")
plot(spatialtempautocorVOD)

spatialtempautocorLSTday<-raster("C:/Users/elkeh/Documents/artikel/LST/Moran3x3_LSTday_SpatialTemporal.tif")
spatialtempautocorLSTday<-resample(spatialtempautocorLSTday, autocorVOD, method="ngb")
plot(spatialtempautocorLSTday)

spatialtempautocorLSTnight<-raster("C:/Users/elkeh/Documents/artikel/LST/Moran3x3_LSTnight_SpatialTemporal.tif")
spatialtempautocorLSTnight<-resample(spatialtempautocorLSTnight, autocorVOD, method="ngb")
plot(spatialtempautocorLSTnight)

EVI.anomalies<- raster("C:/Users/elkeh/Documents/Github_repository_paper/Early-Warning-Signals-Amazonia/results/masked_EVI_Anomalies.tif")
EVI.anomalies <- resample(EVI.anomalies, autocorVOD, method="ngb")

# plot NDVI spatial autocorrelation vs EVI anomalies
stack.rasters<- stack(EVI.anomalies, spatialtempautocorVOD)
EVI.values<- as.data.frame(values(stack.rasters))
EVI.values.outliers<- as.data.frame(sapply(EVI.values, FUN = rm.outlier, fill=TRUE))

scatterPlot(EVI.values.outliers, x = "masked_EVI_Anomalies", y = "Moran3x3_NDVI_SpatialTemporal", method = "hexbin",
            colorcut = seq(0, 1, length = 7), col = c("gray96", "goldenrod"),  linear =TRUE, xlab="EVI anomalies", ylab="Kendall's tau of NDVI derived spatial temporal autocorrelation")

# plot LST day spatial autocorrelation vs EVI anomalies
stack.rasters<- stack(EVI.anomalies, spatialtempautocorLSTday)
EVI.values<- as.data.frame(values(stack.rasters))
EVI.values.outliers<- as.data.frame(sapply(EVI.values, FUN = rm.outlier, fill=TRUE))

scatterPlot(EVI.values.outliers, x = "masked_EVI_Anomalies", y = "Moran3x3_LSTday_SpatialTemporal", method = "hexbin",
            colorcut = seq(0, 1, length = 7), col = c("gray96", "coral1"),  linear =TRUE, xlab="EVI anomalies", ylab="Kendall's tau of LST day derived spatial temporal autocorrelation")


# plot LST day spatial autocorrelation vs EVI anomalies
stack.rasters<- stack(EVI.anomalies, spatialtempautocorLSTnight)
EVI.values<- as.data.frame(values(stack.rasters))
EVI.values.outliers<- as.data.frame(sapply(EVI.values, FUN = rm.outlier, fill=TRUE))

scatterPlot(EVI.values.outliers, x = "masked_EVI_Anomalies", y = "Moran3x3_LSTnight_SpatialTemporal", method = "hexbin",
            colorcut = seq(0, 1, length = 7), col = c("gray96", "orange"),  linear =TRUE, xlab="EVI anomalies", ylab="Kendall's tau of LST night derived spatial temporal autocorrelation")




# plot LST day spatial autocorrelation vs EVI anomalies
stack.rasters<- stack(EVI.anomalies, autocorVOD)
EVI.values<- as.data.frame(values(stack.rasters))
EVI.values.outliers<- as.data.frame(sapply(EVI.values, FUN = rm.outlier, fill=TRUE))

scatterPlot(EVI.values.outliers, x = "masked_EVI_Anomalies", y = "Autocor_NDVI", method = "hexbin",
            colorcut = seq(0, 1, length = 7), col = c("gray96", "tan1"),  linear =TRUE, xlab="EVI anomalies", ylab="Kendall's tau of NDVI derived temporal autocorrelation")

# plot LST day spatial autocorrelation vs EVI anomalies
stack.rasters<- stack(EVI.anomalies, autocorLSTday)
EVI.values<- as.data.frame(values(stack.rasters))
EVI.values.outliers<- as.data.frame(sapply(EVI.values, FUN = rm.outlier, fill=TRUE))

scatterPlot(EVI.values.outliers, x = "masked_EVI_Anomalies", y = "Autocor_LSTday", method = "hexbin",
            colorcut = seq(0, 1, length = 7), col = c("gray96", "goldenrod1"),  linear =TRUE, xlab="EVI anomalies", ylab="Kendall's tau of LST day derived temporal autocorrelation")

# plot LST day spatial autocorrelation vs EVI anomalies
stack.rasters<- stack(EVI.anomalies, autocorLSTnight)
EVI.values<- as.data.frame(values(stack.rasters))
EVI.values.outliers<- as.data.frame(sapply(EVI.values, FUN = rm.outlier, fill=TRUE))

scatterPlot(EVI.values.outliers, x = "masked_EVI_Anomalies", y = "Autocor_LSTnight", method = "hexbin",
            colorcut = seq(0, 1, length = 7), col = c("gray96", "brown1"),  linear =TRUE, xlab="EVI anomalies", ylab="Kendall's tau of LST night derived temporal autocorrelation")



help("scatterPlot")