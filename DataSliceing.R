# Part 3
# Подготовка данных для моделирования

sizeWindow <- 30
trainLength <- round(allRecords * 0.9)

windowBasedData <- NULL
for (i in 1:(allRecords - sizeWindow)) {
  sliceData <-
    c(ds$tShift1[i:(i + sizeWindow - 1)], ifelse(ds$tShift1[i + sizeWindow] >
                                                   0, 1, 0))
  sliceData <- as.data.frame(t(sliceData))
  windowBasedData <- rbind(windowBasedData, sliceData)
}

windowBasedData <- rename(windowBasedData, Raise = V31)

windowBasedData$Raise <- as.factor(windowBasedData$Raise)

windowBasedData %>%
  slice(1:trainLength) -> trainData

windowBasedData %>%
  slice((trainLength + 1):(allRecords - sizeWindow)) -> testData
        