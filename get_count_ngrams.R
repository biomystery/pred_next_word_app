###########################################################################
# 1. load & clean the data (do twitter first because it has the smallest size)
###########################################################################
# read sample lines 
get_tokens <- function(filename="en_US.twitter.txt",num_lines=1000){
  
  df <- file(description = paste0('./data/en_US/',filename))
  raw_data <- readLines(df, n = num_lines)
  close(df)
  
  # Tokenization
  require(tm)
  
  
  # preprocess frmo tm::
  text_data <-removeNumbers(raw_data)
  text_data <- removePunctuation(text_data)
  text_data <- stemDocument(text_data)
  text_data <- stripWhitespace(text_data)
  text_data <- tolower(text_data)
  text_data <- iconv(text_data, "latin1", "ASCII", sub="")
  tokens <- strsplit(text_data,split = " ") # use method 2 
  tokens <- unlist(tokens)
  tokens <- tokens[!tokens == ""]
}

system.time(tw_tokens<- get_tokens(num_lines = 100000)) 
system.time(news_tokens<- get_tokens(file= "en_US.news.txt",num_lines = 100000)) 
system.time(blog_tokens<- get_tokens(file= "en_US.blogs.txt",num_lines = 100000)) 
tokens <- c(tw_tokens,news_tokens,blog_tokens);
save(list = "tokens",file="tokens.RData")

# ----- 
# data table method 
# ----- 
load(file="tokens.RData")
library(data.table)
# 1-3 gram  count 
system.time(count1gramDT<-data.table(w1=tokens)[,.N,by=w1])
system.time(count2gramDT<-data.table(w1=tokens[-length(tokens)],
                                     w2=tokens[-1])[,.N,by=list(w1,w2)])
system.time(count3gramDT<-data.table(w1=tokens[-c(length(tokens),length(tokens)-1)],
                                     w2=tokens[-c(1,length(tokens))],
                                     w3=tokens[-c(1,2)])[,.N,by=list(w1,w2,w3)])
setkey(count1gramDT,"w1")
setkeyv(count2gramDT,c("w1","w2"))
setkeyv(count3gramDT,c("w1","w2","w3"))

save(list=c("count1gramDT","count2gramDT","count3gramDT"),file="count_ngram.RData")
