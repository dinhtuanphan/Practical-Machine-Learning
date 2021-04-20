# Install packages and load library

install.packages('randomForest')
library('randomForest')
install.packages('caret')
library('caret')
install.packages('e1071')
library('e1071')

# Read data frame
a=read.csv('pml-training.csv',na.strings=c('','NA'))
b=a[,!apply(a,2,function(x) any(is.na(x)) )]
c=b[,-c(1:7)]

# For cross validation, split our testing data into sub groups 60:40

subGrps=createDataPartition(y=c$classe, p=0.6, list=FALSE)
subTraining=c[subGrps,]
subTesting=c[-subGrps, ]
dim(subTraining);dim(subTesting)

# Build prediction model based on random forest paradigm

model=randomForest(classe~., data=subTraining, method='class')
pred=predict(model,subTesting, type='class')
z=confusionMatrix(pred,subTesting$classe)
save(z,file='test.RData')

# Load data
load('test.RData')
z$table

# Check the accuracy of model

z$overall[1]

# Analyze the test data set
# Read data frame
d=read.csv('pml-testing.csv',na.strings=c('','NA'))
e=d[,!apply(d,2,function(x) any(is.na(x)) )]
f=e[,-c(1:7)]

# Predict using our model

predicted=predict(model,f,type='class')
save(predicted,file='predicted.RData')

# Check the result

load('predicted.RData')

# Display results
print(predicted)
