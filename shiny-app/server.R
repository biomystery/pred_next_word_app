#--------------------------------------------------
# R Server Code for the Capstone Project Shiny App
#--------------------------------------------------

suppressWarnings(library(shiny))
load(file="model_ngram.RData")


#---------------------------------------
# Description of the Back Off Algorithm
#---------------------------------------

##################################
# Algorithm: 
# 1. Katz back off: 
#    1.1 Start from 3-gram, if found counts, use 3-gram 
#    if not , back off to 2-gram and etc. 
#    1.2 During backoff, using Good-turning smooth to discount, and redistribute 
#    the mass based on  the backed off ratio
# 2. Model: - store in ARPA format
#   \data\: (model.data)
#    ngram 1: number of 1-gram 
#    ngram 2: number of 2-gram 
#    ngram 3: nubmer of 3-gram 
#  \1-gram: (model.1gram)
#   columns: -log10(p_bo(w)), 1-gram, backoff weight a for higher gram 
#  \2-gram: (model.2gram)
#   columns: -log10(p_bo(w2|w1)), 2-gram, backoff weight a for higher gram
#   \3-gram: (model.3gram)
#   columns: -log10(p_bo(w3|w1,w2)), 3-gram  (no need weight since we are starting from 3gram)

# 3. Details about katz back off 
# 3.1 bigram (model.)

# 3. Details about Katz-back off
# 3.1 Calculate p_mle (maximum likelihood prob)
# 3.2 Calculate p_gt (discounted prob,for freq <10 ngram):
# 3.3 Calculate weight a (after discount, redistributed weight) - key
##################################

predic_next_word <- function(input_str){
  
  suppressWarnings(require(data.table))
  
  #clean_tokens <- process_input (input_str)
  input_str <- tolower(input_str)
  
  
  words <- unlist(strsplit(input_str,split = " "))
  nwords <- length(words)
  if(nwords >=2){
    words <- words[(nwords-1):nwords] # use last 3 words
  } else if(nwords == 1){
    words <- c(words,"NA")
  } else {words <- c("NA","NA")}
  
  predDT <- model.3gram[J(words[1],words[2])]  
  
  if(sum(is.na(predDT$p_gt_log10))>0){
    predDT <- model.2gram[J(words[1])]
    if(sum(is.na(predDT$p_gt_log10))){
      predDT <- model.1gram  
    } 
  } 
  
  return(predDT[head(order(predDT$p_gt_log10,decreasing = T)),])  
}

#lapply(c("i understand how", "i know that"), function(x) predic_next_word(x))


##################################
# Algorithm: 
# 1. Katz back off: 
#    1.1 Start from 3-gram, if found counts, use 3-gram 
#    if not , back off to 2-gram and etc. 
#    1.2 During backoff, using Good-turning smooth to discount, and redistribute 
#    the mass based on  the backed off ratio
# 2. Model: - store in ARPA format
#   \data\: (model.data)
#    ngram 1: number of 1-gram 
#    ngram 2: number of 2-gram 
#    ngram 3: nubmer of 3-gram 
#  \1-gram: (model.1gram)
#   columns: -log10(p_bo(w)), 1-gram, backoff weight a for higher gram 
#  \2-gram: (model.2gram)
#   columns: -log10(p_bo(w2|w1)), 2-gram, backoff weight a for higher gram
#   \3-gram: (model.3gram)
#   columns: -log10(p_bo(w3|w1,w2)), 3-gram  (no need weight since we are starting from 3gram)

# 3. Details about katz back off 
# 3.1 bigram (model.)

# 3. Details about Katz-back off
# 3.1 Calculate p_mle (maximum likelihood prob)
# 3.2 Calculate p_gt (discounted prob,for freq <10 ngram):
# 3.3 Calculate weight a (after discount, redistributed weight) - key
##################################


shinyServer(function(input, output) {
  output$prediction <- renderPrint({
    predDF <- predic_next_word(input$inputString);
    
    input$action;
    if("w3" %in% names(predDF)){
      cat("Use 3-gram");
      cat("\n");
      predDF[,.(next_word=w3,prob=10^p_gt_log10)]
    } else if ("w2" %in% names(predDF)){
      cat("Use 2-gram");
      cat("\n");
      predDF[,.(next_word=w2,prob=10^p_gt_log10)]
    } else{
      cat("Use 1-gram");
      cat("\n");
      predDF[,.(next_word=w1,prob=10^p_gt_log10)]}
  })
  
  output$text1 <- renderText({
    paste("Input Sentence: ", input$inputString)});
  
  output$text2 <- renderText({
    input$action;
  })
  
  
}
)