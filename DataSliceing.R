# Part 3
# Подготовка данных для моделирования

sizeWindow <- 30
trainLength <- round(allRecords * 0.9)

windowBasedData <- NULL
for (i in 1:(allRecords - sizeWindow)) {
  sliceData <- as.data.frame(t(ds$V2[i:(i + sizeWindow)]))
  windowBasedData <- rbind(windowBasedData, sliceData)
}

windowBasedData %>%
  select(num_range("V", sizeWindow:(sizeWindow + 1))) %>%
  mutate(Raise = ifelse(.[1] < .[2] , 1, 0)) -> raiseFactor

windowBasedData <- cbind(windowBasedData[1:sizeWindow], raiseFactor[3])
windowBasedData$Raise <- as.factor(windowBasedData$Raise)

windowBasedData %>%
  slice(1:trainLength) -> trainData

windowBasedData %>%
  slice((trainLength + 1):(allRecords - sizeWindow)) -> testData
        