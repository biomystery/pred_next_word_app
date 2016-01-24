#--------------------------------------------------
# R UI Code for the Capstone Project Shiny App
#--------------------------------------------------

suppressWarnings(library(shiny))

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Predict Next Word"),
  
  fluidRow(HTML("<strong>Author: Frank Cheng</strong>") ),
  fluidRow(HTML("<strong>Date: 2016-01-24 </strong>") ),
  fluidRow(HTML("<strong>ver: 0.1 </strong>") ),
  
  fluidRow(
    br(),
    p("This Shiny application uses 3-gram Katz Back Off model to predict next unseen word in the user entered words sequence.
The model is trained by us-news, us-blogs and us-twitters. ")),
  br(),
  br(),
  
  fluidRow(HTML("<strong>Enter an incomplete sentence. Press \"Next Word\" button to predict the next word</strong>") ),
  fluidRow( p("\n") ),
  fluidRow( p("It will return top 5 words with probality for each word. (first predict will take a little time to load data, and later it will be fast)") ),
  # Sidebar layout
  sidebarLayout(
    
    sidebarPanel(
      textInput("inputString", "Enter a partial sentence here",value = ""),
      submitButton("Next Word")
    ),
    
    mainPanel(
      h4("Predicted Next Word"),
      verbatimTextOutput("prediction"),
      textOutput('text1'),
      textOutput('text2'),
      textOutput('text3')
      
    )
  )
    ))