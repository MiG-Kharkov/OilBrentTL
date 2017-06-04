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
rfFit <-
  train(
    Raise ~ .,
    data = trainData,
    method = "rf",
    trControl = ctrl,
    tuneLength = 3
  )
rfFit
# Random Forest 
# 
# 6855 samples
# 30 predictor
# 2 classes: '0', '1' 
# 
# No pre-processing
# Resampling: Cross-Validated (10 fold, repeated 3 times) 
# Summary of sample sizes: 6170, 6169, 6169, 6170, 6169, 6170, ... 
# Resampling results across tuning parameters:
#   
#   mtry  Accuracy   Kappa     
# 2    0.5201981  0.03422195
# 16    0.5233112  0.04124285
# 30    0.5243342  0.04313317
# 
# Accuracy was used to select the optimal model using  the largest value.
# The final value used for the model was mtry = 30.

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

knnFit
# k-Nearest Neighbors 
# 
# 6855 samples
# 30 predictor
# 2 classes: '0', '1' 
# 
# No pre-processing
# Resampling: Cross-Validated (10 fold, repeated 3 times) 
# Summary of sample sizes: 6169, 6169, 6170, 6169, 6170, 6169, ... 
# Resampling results across tuning parameters:
#   
#   k   Accuracy   Kappa     
# 5  0.5210838  0.03811022
# 7  0.5198208  0.03502128
# 9  0.5198683  0.03400540
# 11  0.5179216  0.02966450
# 13  0.5218610  0.03664417
# 15  0.5149562  0.02218618
# 17  0.5153937  0.02279340
# 19  0.5128645  0.01708174
# 21  0.5113553  0.01348067
# 23  0.5130580  0.01685405
# 25  0.5129108  0.01626722
# 27  0.5140774  0.01809427
# 29  0.5167999  0.02332974
# 31  0.5177252  0.02510494
# 33  0.5203501  0.03040405
# 35  0.5183578  0.02606487
# 37  0.5210794  0.03115754
# 39  0.5202036  0.02929306
# 41  0.5200582  0.02862983
# 43  0.5169455  0.02219816
# 
# Accuracy was used to select the optimal model using  the largest value.
# The final value used for the model was k = 13.
set.seed(123)
grid <- expand.grid(k=12:14)
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
# -13.857  -0.182 -14.083 

knnFit
# k-Nearest Neighbors 
# 
# 6855 samples
# 30 predictor
# 2 classes: '0', '1' 
# 
# No pre-processing
# Resampling: Cross-Validated (10 fold, repeated 3 times) 
# Summary of sample sizes: 6169, 6169, 6170, 6169, 6170, 6169, ... 
# Resampling results across tuning parameters:
#   
#   k   Accuracy   Kappa     
# 12  0.5180681  0.02994637
# 13  0.5219581  0.03683099
# 14  0.5206947  0.03437618
# 
# Accuracy was used to select the optimal model using  the largest value.
# The final value used for the model was k = 13.

