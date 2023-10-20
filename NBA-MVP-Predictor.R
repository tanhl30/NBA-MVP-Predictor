library(dplyr)
library(corrplot)
library(car)
library(leaps)

#Data cleaning 
top5 = read.csv('top5.csv',na.strings="NA")
top5 = top5%>%select(-c('WS.1','WS.48.1'))%>%filter(Year<2023)

stat_2023 = read.csv('Player Stat 2023.csv',na.strings="NA")

#Scaling 
Scale_factor = 82/72
top5 <- top5 %>%
  mutate(G = case_when(Year == 2020 ~ G * Scale_factor,TRUE ~ G ),
         WS = case_when(Year == 2020 ~ WS * Scale_factor,TRUE ~ WS),
         OWS = case_when(Year == 2020 ~ OWS * Scale_factor,TRUE ~ OWS),
         DWS = case_when(Year == 2020 ~ DWS * Scale_factor,TRUE ~ DWS),
         VORP = case_when( Year == 2020 ~ VORP * Scale_factor,TRUE ~ VORP)
  )
#fit lm
lm.fit1 = lm(Share~G+MP+TRB+AST+STL+BLK+FG.+X3P.+FT.+WS+PER+VORP+Team.Wins+OWS+DWS+TS.+WS.48+OBPM+DBPM+BPM,data=top5)

lm.fit2 = lm(Share~G+MP+TRB+AST+STL+BLK+FG.+X3P.+FT.+WS+PER+VORP+Team.Wins,data=top5)

vif(lm.fit1)
vif(lm.fit2)

#Cross validation
predict.regsubsets=function(object,newdata,id,...){
  form=as.formula(object$call[[2]])
  mat=model.matrix(form,newdata)
  coefi=coef(object,id=id)
  xvars=names(coefi)
  mat[,xvars]%*%coefi
}
top51 = top5%>%select(c('Share','G','MP','TRB','AST','STL','BLK','FG.','X3P.','FT.','WS','PER','VORP','Team.Wins'))
k=10
n=nrow(top51)

set.seed(1)
folds=sample(rep(1:k,length=n))
cv.errors=matrix(NA,k,13, dimnames=list(NULL, paste(1:13)))
for(j in 1:k){
  best.fit=regsubsets(Share~.,data=top51[folds!=j,],nvmax=13)
  for(i in 1:13){
    pred=predict(best.fit,top51[folds==j,],id=i)
    cv.errors[j,i]=mean( (top51$Share[folds==j]-pred)^2)
  }
}
mean.cv.errors=apply(cv.errors,2,mean)
plot(mean.cv.errors,type='b',xlab='Number of predictors')

reg.best=regsubsets(Share~.,data=top51,nvmax=13)

coef(reg.best,3)

#Prediction of 2023

lm.fit3 = lm(Share~PER+VORP+Team.Wins,data=top5)

prediction = predict(lm.fit3,newdata=stat_2023)
head(data.frame(stat_2023['Player'],prediction)%>%arrange(desc(prediction)))
