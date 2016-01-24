N-Gram Word Predictor: Data Science Capstone
========================================================
author: Frank Cheng
date: Jan 24, 2016


Overview
========================================================

If you haven't tried out the app, go (https://biomystery.shinyapps.io/predNextWord/) to try it!

- Predicts next word
- Shows you top 5 words with probablities for each prediction
- It is fast after loading the model data

Data processing
========================================================
It is done following these steps:

1. Tokenize: wrote a get_tokens function, taking files and return tokens

2. get n-grams freqency: use data.table library process data quite fast

Algorithm
========================================================
From n-gram freqency data: 

1. Apply Good-Turning discounting for freq<10 1,2,3-gram 

2. Using Katz-back off to calculate the p_kz(w3|w1,w2), p_kz(w1|w2)

3. Store the model using the [ARPA format](http://www.speech.sri.com/projects/srilm/manpages/ngram-format.5.html)


Algorithm (extended)
========================================================
From n-gram freqency data: 
1. Apply Good-Turning discounting for freq<10 1,2,3-gram 
2. Using Katz-back off to calculate the p_kz(w3|w1,w2), p_kz(w1|w2)
3. Store the model using the [ARPA format](http://www.speech.sri.com/projects/srilm/manpages/ngram-format.5.html)

Final Product
========================================================
![](app_screen_shot.png)
