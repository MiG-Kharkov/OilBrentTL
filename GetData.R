# Part 1
# Блок загрузки данных
if (!require("tseries")) install.packages("tseries")
if (!require("forecast")) install.packages("forecast")
if(!"recommenderlab" %in% rownames(installed.packages())){install.packages("recommenderlab")}
library(ggplot2)
library(data.table)
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
allRecords <- nrow(ds)

# добавим временные разницы к данным
ds$tShift1 <- c(0,ds$V2[2:allRecords]-ds$V2[1:(allRecords-1)])
ds$tShift2 <- c(0,0,ds$V2[3:allRecords]-ds$V2[1:(allRecords-2)])
ds$tShift5 <- c(0,0,0,0,0,ds$V2[6:allRecords]-ds$V2[1:(allRecords-5)])
