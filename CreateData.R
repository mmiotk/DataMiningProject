createData = function (string,howMuch) {
  result = searchTwitteR(paste("#",string),lang="en",n=howMuch,cainfo=system.file("CurlSSL","cacert.pem",package="RCurl"))
  result.df = twListToDF(result)
  write.csv(result.df,paste("Data/",string,".csv",sep=""),row.names=FALSE)
}


