#--------------------------------------------------
# R Server Code for the Capstone Project Shiny App
#--------------------------------------------------

suppressWarnings(library(shiny))

load(file="model_ngram.RData")
mesg <- as.character(NULL);


#---------------------------------------
# Description of the Back Off Algorithm
#---------------------------------------

source(file="predic_next_term.R")

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