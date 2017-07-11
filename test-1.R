# раздел для предварительного анализа данных и обработка очевидных выбросов

if (!require("readxl")) install.packages("readxl") #read excel files
if (!require("dplyr")) install.packages("dplyr") # a grammar of data manipulation
if (!require("zoo")) install.packages("zoo") #times series
if (!require("xts")) install.packages("xts") #times series
library(readxl)
library(zoo)
library(xts)
library(dplyr)
library(grDevices)


# считываем данные

dataset<-read_excel("inputs.xlsx", na="NA")
dataset<-as.data.frame(dataset)
# Look at data 
summary(dataset)
head(dataset)

# Предварительная обработа данных, на отсутствующие значения, очевидные выбросы с устранением этих проблем для последующей
# работы с данными. Некоторые ряды содержат пропущенные данные данные в начале

#columns TS3, TS4 have missing data at the begining

Idx<-as.Date(dataset[,1]) # зададим вектор с датами
start1<-as.numeric(first(which(dataset[,2]!="NA"))) #первый элемент != NA
start2<-as.numeric(first(which(dataset[,3]!="NA")))
start3<-as.numeric(first(which(dataset[,4]!="NA"))) 
start4<-as.numeric(first(which(dataset[,5]!="NA")))
start5<-as.numeric(first(which(dataset[,6]!="NA")))
length_raw<-as.numeric(length(dataset$date)) # всего элементов в каждом ряду

# преобразуем столбцы данных во временные ряды
TS1 <-xts(dataset[start1:length_raw,2], order.by=Idx[start1:length_raw])
TS2 <-xts(dataset[start2:length_raw,3],order.by=Idx[start2:length_raw])
TS3 <-xts(dataset[start3:length_raw,4],order.by=Idx[start3:length_raw])
TS4 <-xts(dataset[start4:length_raw,5],order.by=Idx[start4:length_raw])
TS5 <-xts(dataset[start5:length_raw,6],order.by=Idx[start5:length_raw])

# Посмотрим на оставшиеся очевидные проблемы в рядах.
summary(TS1)
summary(TS2)
summary(TS3)
summary(TS4)
summary(TS5)

#Сильно выделяющиеся значения заменены на подходящие. Для пропущенных используется среднее, опечатки исправлены в соответствии с подходящим значением.
# Some elements in times series look like having misprinting and missing values
# TS1 (max 1194,8 is suspicios)

pdf(file='graphs.pdf')
par(mfrow=c(2,1))
t=first(which(TS1>900)) # посмотрим на экстремально большие значения в ряду TS1
TS1[(t-10):(t+10)] # и поведение ряда в окрестности этой точки
plot(TS1[(t-10):(t+10)],xlab = "", ylab = "", main = paste("Misprinting point in TS1 at ", Idx[t+start1-1]),xaxt='n')
points(TS1[t], col="red",pch = 19)
TS1[t]<-TS1[t]/10 # исправим опечатку в данных
plot(TS1[(t-10):(t+10)],xlab = "", ylab = "",main = paste("Corrected Data in TS1 at ",  Idx[t+start1-1]), xaxt='n')
points(TS1[t], col="green",pch = 19)


#TS4
# TS4 has element equal to NA, look at the its Neighbourhood
par(mfrow=c(2,1))
t<-last(which(is.na(TS4))) # пропущенное значение в данных
plot(TS4[(t-30):(t+30)],xlab = "", ylab = "", main = paste("Missing point in TS4 at ", Idx[t+start4-1]),xaxt='n') 
TS4[t]<-mean(TS4[(t-10):(t+10)],na.rm = TRUE) #according to nearby elements change its value to  average one
plot(TS4[(t-30):(t+30)],xlab = "", ylab = "",main = paste("Corrected Data in TS4 at ",  Idx[t+start4-1]), xaxt='n')
points(TS4[t], col="green",pch = 19)

# min 100.0318 is suspicios
par(mfrow=c(2,1))
t=first(which(TS4<9000))  # посмотрим на экстремально маленькое значение в ряду TS4
TS4[(t-2):(t+10)]
plot(TS4[(t-2):(t+10)],xlab = "", ylab = "", main = paste("Misprinting point in TS4 at ", Idx[t+start4-1]),xaxt='n') 
points(TS4[t], col="red",pch = 19)
TS4[t]<-TS4[t]*100 # исправим опечатку
plot(TS4[(t-2):(t+10)],xlab = "", ylab = "",main = paste("Corrected Data in TS4 at ",  Idx[t+start4-1]), xaxt='n')
points(TS4[t], col="green",pch = 19)

#TS5 min 0 is suspicios
par(mfrow=c(2,1))
t=first(which(TS5<10)) # Подозрительное значение
TS5[(t-10):(t+10)]
plot(TS5[(t-10):(t+10)],xlab = "", ylab = "", main = paste("Missing point in TS5 at ", Idx[t+start5-1]),xaxt='n') 
points(TS5[t], col="red",pch = 19)
TS5[t]<-NA
TS5[t]<-mean(TS5[(t-5):(t+5)],na.rm = TRUE) # заменим его средним
plot(TS5[(t-10):(t+10)],xlab = "", ylab = "",main = paste("Corrected Data in TS5 at ",  Idx[t+start5-1]), xaxt='n')
points(TS5[t], col="green",pch = 19)

dev.off()



















