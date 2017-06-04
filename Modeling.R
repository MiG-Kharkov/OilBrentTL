# Part 4
# Построение и обучение модели
library(caret)
library(e1071)

# sizeWindow = 30
# 
## For a gradient boosting machine (GBM) model, there are three main tuning parameters:
#
# - number of iterations, i.e. trees, (called n.trees in the gbm function)
# - complexity of the tree, called interaction.depth
# - learning rate: how quickly the algorithm adapts, called shrinkage
# - the minimum number of training set samples in a node
#   to commence splitting (n.minobsinnode)

fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 10,
  ## repeated 3 times
  repeats = 3)

set.seed(123)
startTimeCalculatio <- proc.time()
gbmFit <- train(
  Raise ~ .,
  data = trainData,
  method = "gbm",
  trControl = fitControl,
  ## This last option is actually one
  ## for gbm() that passes through
  verbose = FALSE
)
startTimeCalculatio - proc.time()
# user   system  elapsed 
# -90.507  -0.646 -91.166 

gbmFit
################################# Shift5
# Stochastic Gradient Boosting 
# 
# 6855 samples
# 30 predictor
# 2 classes: '0', '1' 
# 
# No pre-processing
# Resampling: Cross-Validated (10 fold, repeated 3 times) 
# Summary of sample sizes: 6169, 6170, 6168, 6169, 6170, 6170, ... 
# Resampling results across tuning parameters:
#   
#   interaction.depth  n.trees  Accuracy   Kappa    
# 1                   50      0.7982950  0.5916805
# 1                  100      0.8202728  0.6376080
# 1                  150      0.8294142  0.6562493
# 2                   50      0.8163351  0.6297374
# 2                  100      0.8324799  0.6625231
# 2                  150      0.8373417  0.6723777
# 3                   50      0.8267906  0.6510312
# 3                  100      0.8384112  0.6745603
# 3                  150      0.8409395  0.6797384
# 
# Tuning parameter 'shrinkage' was held constant at a value of 0.1
# Tuning
# parameter 'n.minobsinnode' was held constant at a value of 10
# Accuracy was used to select the optimal model using  the largest value.
# The final values used for the model were n.trees = 150, interaction.depth = 3, shrinkage
# = 0.1 and n.minobsinnode = 10.

## Trying to predinct with Random Forest
ctrl <- trainControl(method = "repeatedcv", repeats = 3)
startTimeCalculatio <- proc.time()
rfFit <-
  train(
    Raise ~ .,
    data = trainData,
    method = "rf",
    trControl = ctrl,
    tuneLength = 3
  )
startTimeCalculatio - proc.time()
# user    system   elapsed 
# -1021.104   -11.083 -1033.556 
rfFit
################################# Shift5
# Random Forest 
# 
# 6855 samples
# 30 predictor
# 2 classes: '0', '1' 
# 
# No pre-processing
# Resampling: Cross-Validated (10 fold, repeated 3 times) 
# Summary of sample sizes: 6170, 6170, 6170, 6170, 6170, 6169, ... 
# Resampling results across tuning parameters:
#   
#   mtry  Accuracy   Kappa    
# 2    0.8211972  0.6388594
# 16    0.8298052  0.6578388
# 30    0.8279092  0.6539766
# 
# Accuracy was used to select the optimal model using  the largest value.
# The final value used for the model was mtry = 16.

## k-Nearest Neighbors 

set.seed(123)
ctrl <- trainControl(method="repeatedcv",repeats = 3)

# Для начала определим область поиска значений параметра.
startTimeCalculatio <- proc.time()
knnFit <- train(
  Raise ~ .,
  data = trainData,
  method = "knn",
  trControl = ctrl,
  tuneLength = 20
)
startTimeCalculatio - proc.time()
# user  system elapsed 
# -95.024  -1.264 -96.644 

knnFit
################################# Shift5
# k-Nearest Neighbors 
# 
# 6855 samples
# 30 predictor
# 2 classes: '0', '1' 
# 
# No pre-processing
# Resampling: Cross-Validated (10 fold, repeated 3 times) 
# Summary of sample sizes: 6169, 6170, 6168, 6169, 6170, 6170, ... 
# Resampling results across tuning parameters:
#   
#   k   Accuracy   Kappa    
# 5  0.7167029  0.4282726
# 7  0.7355696  0.4661359
# 9  0.7456835  0.4861480
# 11  0.7554071  0.5057486
# 13  0.7625551  0.5199579
# 15  0.7677575  0.5302606
# 17  0.7753909  0.5456146
# 19  0.7746612  0.5439016
# 21  0.7763640  0.5471856
# 23  0.7804489  0.5554654
# 25  0.7847268  0.5639286
# 27  0.7842414  0.5626805
# 29  0.7856018  0.5653238
# 31  0.7859432  0.5659640
# 33  0.7876939  0.5695539
# 35  0.7889088  0.5721656
# 37  0.7911950  0.5766768
# 39  0.7932854  0.5810275
# 41  0.7951821  0.5847655
# 43  0.7968858  0.5881155
# 
# Accuracy was used to select the optimal model using  the largest value.
# The final value used for the model was k = 43.
set.seed(123)
grid <- expand.grid(k=43:50)
startTimeCalculatio <- proc.time()
knnFit <- train(
  Raise ~ .,
  data = trainData,
  method = "knn",
  trControl = ctrl,
  tuneGrid = grid
)
startTimeCalculatio - proc.time()
# user  system elapsed 
# -43.321  -0.653 -44.277 

knnFit
################################# Shift5
# k-Nearest Neighbors 
# 
# 6855 samples
# 30 predictor
# 2 classes: '0', '1' 
# 
# No pre-processing
# Resampling: Cross-Validated (10 fold, repeated 3 times) 
# Summary of sample sizes: 6169, 6170, 6168, 6169, 6170, 6170, ... 
# Resampling results across tuning parameters:
#   
#   k   Accuracy   Kappa    
# 43  0.7967884  0.5879061
# 44  0.7970310  0.5883626
# 45  0.7985396  0.5914573
# 46  0.7972741  0.5888359
# 47  0.7980536  0.5903914
# 48  0.7995603  0.5935059
# 49  0.8002423  0.5947666
# 50  0.8012625  0.5968246
# 
# Accuracy was used to select the optimal model using  the largest value.
# The final value used for the model was k = 50.

