xts(ds$V2, order.by = ds$V1) -> oil.xts
# xts(ds$tShift1, order.by = ds$V1) -> oil.xts.shift1
# xts(ds$tShift2, order.by = ds$V1) -> oil.xts.shift2
# xts(ds$tShift5, order.by = ds$V1) -> oil.xts.shift5

tsdisplay(oil.xts)
df.oil.xts <- diff(oil.xts)
tsdisplay(df.oil.xts)

sizeWindow <- 30
nPrediction <- 10

oil.xts[
  (allRecords - sizeWindow - nPrediction):(allRecords - nPrediction)
  ] -> train.oil.xts

# автоматический подбор модели
mod_a <- auto.arima(train.oil.xts)
summary(mod_a)
tsdiag(mod_a)
# прогнозируем на 20 шагов вперед
(fc_a <- forecast(mod_a, h = nPrediction))
plot(fc_a)
