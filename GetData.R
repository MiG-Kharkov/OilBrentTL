# Part 1
# Блок загрузки данных
if (!require("tseries")) install.packages("tseries")
if (!require("forecast")) install.packages("forecast")
library(ggplot2)
library(data.table)
library(dplyr)
library(tseries)
library(forecast)
library(zoo)
library(xts)
library(dplyr)
library(grDevices)
# Data set 
# https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=PET&s=rbrte&f=D
ds <- fread("Europe_Brent_Spot_Price_FOB.csv", skip = 5)
ds$V1 <- as.Date(ds$V1, format = "%m/%d/%Y")

oil.xts <- xts(ds$V2, order.by = ds$V1)
