library(h2o)

## start a local h2o cluster
localH2O = h2o.init(max_mem_size = '6g', # use 6GB of RAM of *GB available
                    nthreads = -1) # use all CPUs (8 on my personal computer :3)

## MNIST data as H2O
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
# -0.485  -0.022  -6.768 

## print confusion matrix
h2o.confusionMatrix(model)
# Confusion Matrix (vertical: actual; across: predicted)  for max f1 @ threshold = 0.469777047781609:
#          0    1    Error        Rate
# 0      283 3296 0.920928  =3296/3579
# 1       92 3488 0.025698    =92/3580
# Totals 375 6784 0.473250  =3388/7159

## classify test set
h2o_y_test <- h2o.predict(model, test_h2o)

## convert H2O format into data frame 
df_y_test = as.data.frame(h2o_y_test)
df_y_test$predict <- ifelse(df_y_test$p1 < 0.5, 0, 1)
df_y_test$actual <- testData$Raise
confusionMatrix(df_y_test$predict, df_y_test$actual)
# Confusion Matrix and Statistics
# 
#             Reference
# Prediction   0   1
# 0           79  72
# 1           308 273
# 
# Accuracy : 0.4809          
# 95% CI : (0.4441, 0.5178)
# No Information Rate : 0.5287          
# P-Value [Acc > NIR] : 0.9957          
# 
# Kappa : -0.0044         
# Mcnemar's Test P-Value : <2e-16          
# 
# Sensitivity : 0.2041          
# Specificity : 0.7913          
# Pos Pred Value : 0.5232          
# Neg Pred Value : 0.4699          
# Prevalence : 0.5287          
# Detection Rate : 0.1079          
# Detection Prevalence : 0.2063          
# Balanced Accuracy : 0.4977          
# 
# 'Positive' Class : 0  

## shut down virutal H2O cluster
h2o.shutdown(prompt = F)
