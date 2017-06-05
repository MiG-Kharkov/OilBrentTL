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
  repeats = 10)
gbmGrid <-  expand.grid(interaction.depth = c(1, 5, 9), 
                        n.trees = (1:30)*50, 
                        shrinkage = 0.1,
                        n.minobsinnode = 20)
set.seed(123)
startTimeCalculatio <- proc.time()
gbmFit <- train(Raise ~ .,data = trainData,
  method = "gbm",
  trControl = fitControl,
  ## This last option is actually one
  ## for gbm() that passes through
  verbose = FALSE,
  ## Now specify the exact models 
  ## to evaluate:
  tuneGrid = gbmGrid
)
startTimeCalculatio - proc.time()
# user    system   elapsed 
# -5789.775   -11.074 -5804.945 

gbmFit
# Stochastic Gradient Boosting 
# 
# 6855 samples
# 30 predictor
# 2 classes: '0', '1' 
# 
# No pre-processing
# Resampling: Cross-Validated (10 fold, repeated 10 times) 
# Summary of sample sizes: 6169, 6170, 6168, 6169, 6170, 6170, ... 
# Resampling results across tuning parameters:
#   
#   interaction.depth  n.trees  Accuracy   Kappa    
# 1                    50     0.7987584  0.5926768
# .....
# 5                  1450     0.8293630  0.6567213
# 5                  1500     0.8293634  0.6567102
# 9                    50     0.8403047  0.6785872
# 9                   100     0.8424929  0.6830974
# 9                   150     0.8406840  0.6794337
# ......
# Tuning parameter 'shrinkage' was held constant at a value of 0.1
# Tuning
# parameter 'n.minobsinnode' was held constant at a value of 20
# Accuracy was used to select the optimal model using  the largest value.
# The final values used for the model were n.trees = 100, interaction.depth = 9, shrinkage
# = 0.1 and n.minobsinnode = 20.
plot(gbmFit)

# Меняем папаметры обучения
fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 10,
  ## repeated 3 times
  repeats = 3)
gbmGrid <-  expand.grid(interaction.depth = c(3,5,7,9), 
                        n.trees = (3:5)*25, 
                        shrinkage = 0.1,
                        n.minobsinnode = 20)
set.seed(123)
startTimeCalculatio <- proc.time()
gbmFit <- train(Raise ~ .,data = trainData,
                method = "gbm",
                trControl = fitControl,
                ## This last option is actually one
                ## for gbm() that passes through
                verbose = FALSE,
                ## Now specify the exact models 
                ## to evaluate:
                tuneGrid = gbmGrid
)
startTimeCalculatio - proc.time()
# user    system   elapsed 
# 806.490   -4.170 -810.707 

gbmFit
# Stochastic Gradient Boosting 
# 
# 6855 samples
# 30 predictor
# 2 classes: '0', '1' 
# 
# No pre-processing
# Resampling: Cross-Validated (10 fold, repeated 10 times) 
# Summary of sample sizes: 6169, 6170, 6168, 6169, 6170, 6170, ... 
# Resampling results across tuning parameters:
#   
#   interaction.depth  n.trees  Accuracy   Kappa    
# 3                   75      0.8345568  0.6667896
# 3                  100      0.8384081  0.6745888
# 3                  125      0.8400416  0.6779234
# 5                   75      0.8405960  0.6791215
# 5                  100      0.8421724  0.6823403
# 5                  125      0.8415595  0.6810990
# 7                   75      0.8425509  0.6831111
# 7                  100      0.8419673  0.6820070
# 7                  125      0.8419962  0.6820649
# 9                   75      0.8414129  0.6808801
# 9                  100      0.8423608  0.6827950
# 9                  125      0.8418206  0.6817381
# 
# Tuning parameter 'shrinkage' was held constant at a value of 0.1
# Tuning
# parameter 'n.minobsinnode' was held constant at a value of 20
# Accuracy was used to select the optimal model using  the largest value.
# The final values used for the model were n.trees = 75, interaction.depth = 7, shrinkage
# = 0.1 and n.minobsinnode = 20.

# Лучший без проверки
fitControl <- train(method = "none", classProbs = TRUE)
gbmGrid <-  expand.grid(interaction.depth = 7, 
                        n.trees = 75, 
                        shrinkage = 0.1,
                        n.minobsinnode = 20)
set.seed(123)
startTimeCalculatio <- proc.time()
gbmFit <- train(Raise ~ .,data = trainData,
                method = "gbm",
                trControl = fitControl,
                ## This last option is actually one
                ## for gbm() that passes through
                verbose = FALSE,
                ## Now specify the exact models 
                ## to evaluate:
                tuneGrid = gbmGrid
)
startTimeCalculatio - proc.time()
# user    system   elapsed 
# -151.464   -1.406 -153.438 

gbmFit
# Accuracy   Kappa    
# 0.8424494  0.6829252

df_y_test <- predict(gbmFit, testData[-(sizeWindow+1)], type = "prob")
df_y_test$predict <- ifelse(df_y_test$`0` > 0.5, 0, 1)
df_y_test$actual <- testData$Raise
confusionMatrix(df_y_test$predict, df_y_test$actual)
# Confusion Matrix and Statistics
# 
# Reference
# Prediction   0   1
# 0 342  72
# 1  50 268
# 
# Accuracy : 0.8333          
# 95% CI : (0.8043, 0.8596)
# No Information Rate : 0.5355          
# P-Value [Acc > NIR] : < 2e-16         
# 
# Kappa : 0.6635          
# Mcnemar's Test P-Value : 0.05727         
# 
# Sensitivity : 0.8724          
# Specificity : 0.7882          
# Pos Pred Value : 0.8261          
# Neg Pred Value : 0.8428          
# Prevalence : 0.5355          
# Detection Rate : 0.4672          
# Detection Prevalence : 0.5656          
# Balanced Accuracy : 0.8303          
# 
# 'Positive' Class : 0    