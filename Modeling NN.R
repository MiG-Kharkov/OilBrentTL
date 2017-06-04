# Part 4.2
# Модериуем внейронной сети прогноз
library(h2o)

## start a local h2o cluster
localH2O = h2o.init(max_mem_size = '6g', # use 6GB of RAM of *GB available
                    nthreads = -1) # use all CPUs (8 on my personal computer :3)

## MNIST data as H2O
################################# Shift5
train_h2o = as.h2o(trainData)
test_h2o = as.h2o(testData)

## set timer
s <- proc.time()
## train model
model =
  h2o.deeplearning(x = 1:30,  # column numbers for predictors
                   y = 31,   # column number for label
                   training_frame = train_h2o, # data in H2O format
                   activation = "RectifierWithDropout", # algorithm
                   input_dropout_ratio = 0.2, # % of inputs dropout
                   hidden_dropout_ratios = c(0.5,0.5), # % for nodes dropout
                   balance_classes = TRUE, 
                   hidden = c(300,300), # two layers of 100 nodes
                   momentum_stable = 0.99,
                   nesterov_accelerated_gradient = T, # use it for speed
                   epochs = 15) # no. of epochs

## print time elapsed
s - proc.time()
# user  system elapsed 
# -0.300  -0.029  -8.562 

## print confusion matrix
h2o.confusionMatrix(model)
# Confusion Matrix (vertical: actual; across: predicted)  for max f1 @ threshold = 0.426967207980168:
#          0    1    Error        Rate
# 0      3014  647 0.176728   =647/3661
# 1       383 3240 0.105713   =383/3623
# Totals 3397 3887 0.141406  =1030/7284

## classify test set
h2o_y_test <- h2o.predict(model, test_h2o)

## convert H2O format into data frame 
df_y_test = as.data.frame(h2o_y_test)
df_y_test$predict <- ifelse(df_y_test$p1 < 0.5, 0, 1)
df_y_test$actual <- testData$Raise
confusionMatrix(df_y_test$predict, df_y_test$actual)
# Confusion Matrix and Statistics
# 
# Reference
# Prediction   0   1
# 0 354  75
# 1  38 265
# 
# Accuracy : 0.8456          
# 95% CI : (0.8174, 0.8711)
# No Information Rate : 0.5355          
# P-Value [Acc > NIR] : < 2.2e-16       
# 
# Kappa : 0.6874          
# Mcnemar's Test P-Value : 0.0007077       
# 
# Sensitivity : 0.9031          
# Specificity : 0.7794          
# Pos Pred Value : 0.8252          
# Neg Pred Value : 0.8746          
# Prevalence : 0.5355          
# Detection Rate : 0.4836          
# Detection Prevalence : 0.5861          
# Balanced Accuracy : 0.8412          
# 
# 'Positive' Class : 0

h2o.shutdown(prompt = F)


