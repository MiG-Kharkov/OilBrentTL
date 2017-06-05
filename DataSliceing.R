# Part 3
# Подготовка данных для моделирования


## Окно 30 + 1 растет 0 не растет
sizeWindow <- 30
trainLength <- round(allRecords * 0.9)

windowBasedData <- NULL
for (i in 1:(allRecords - sizeWindow)) {
  sliceData <-
    c(ds$tShift1[i:(i + sizeWindow - 1)], ifelse(ds$tShift2[i + sizeWindow] >
                                                   0, 1, 0))
  sliceData <- as.data.frame(t(sliceData))
  windowBasedData <- rbind(windowBasedData, sliceData)
}

windowBasedData <- dplyr::rename(windowBasedData, Raise = V31)

windowBasedData$Raise <- as.factor(windowBasedData$Raise)

windowBasedData %>%
  slice(1:trainLength) -> trainData

windowBasedData %>%
  slice((trainLength + 1):(allRecords - sizeWindow)) -> testData
        