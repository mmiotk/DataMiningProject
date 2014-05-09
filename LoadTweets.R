#Sentiment function

library(plyr)
library(stringr)
library(ggplot2)

score.sentiment = function(sentences,positive.words,negative.words, .progress='none'){
  require(plyr)
  require(stringr)
  require(ggplot2)
  
  scores = laply(sentences, function(sentence, positive.words, negative.words) {
    sentence = gsub("@\\w+", "", sentence)
    sentence = gsub('[[:punct:]]', '',sentence)
    sentence = gsub('[[:cntrl:]]', '',sentence)
    sentence = gsub('\\d+', '', sentence)
    sentence = gsub("http\\w+", "", sentence)
    sentence = gsub("RT|via", "", sentence)
    sentence = gsub("http", "", sentence)
      
    sentence = tolower(sentence)
    
    word.list = str_split(sentence,'\\s+')
    words = unlist(word.list)
    
    positive.matches = match(words,positive.words)
    negative.matches = match(words,negative.words)
    
    positive.matches = !is.na(positive.matches)
    negative.matches = !is.na(negative.matches)
  
    score = sum(positive.matches) - sum(negative.matches)
    return (score)
    
  }, positive.words, negative.words, .progress=.progress)
  
  scores.df = data.frame(score = scores, text=sentences)
  return(scores.df)
  
}

sentimentFunction = function(filename){
  data = read.csv(filename)
  data$text = as.factor(data$text)
  data.score = score.sentiment(data$text,words.pos,words.neg)
  write.csv(data.score,file=filename,row.names=TRUE)
  filename = basename(filename)
  filename = gsub(".csv","",filename)
  plot = qplot(data.score$score,main=paste("Histogram dla",filename),ylab="Ilość tweetów",xlab="Wartość opinii",geom="histogram")
  ggsave(plot,file=paste("Data/Hist",filename,".png",sep=""))
  mean = round(mean(data.score$score),2)
  sd = round(sd(data.score$score),2)
  sumPositive = sum(data.score$score > 0)
  sumNegative = sum(data.score$score < 0)
  sumNeutral = sum(data.score$score == 0)
  print(paste("Średnia dla",filename,"wynosi ",mean))
  print(paste("Odchylenie standardowe dla",filename,"wynosi",sd))
  print(paste("Suma pozytywnych wynosi",sumPositive))
  print(paste("Suma negatywnych wynosi",sumNegative))
  print(paste("Suma neutralnych wynosi",sumNeutral))
}









