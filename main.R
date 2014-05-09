setwd(getwd())
source("LoadTweets.R")
source("CreateData.R")

require(twitteR)
library(plyr)
library(stringr)
library(ggplot2)

load("twitCred.RData")
registerTwitterOAuth(twitCred)

words.pos = scan('positive-words.txt',what='character')
words.neg = scan('negative-words.txt',what='character')

words = c("drugs","alcohol","racism","marriage","work","car")

sapply(words,function(x) createData(x,500))
sapply(words,function(x) sentimentFunction(paste("Data/",x,".csv",sep="")))
