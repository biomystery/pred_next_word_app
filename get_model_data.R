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
load(file="count_ngram.RData")
# calculate model.1gram 
Nr_gram <- lapply(1:3, 
                  function(x)
                    eval(parse(text = paste0(
                      "sapply(1:10, function(r) sum(count",x,"gramDT$N==r))")))
)
# ngram number 
model.data_num <- sapply(list(count1gramDT,count2gramDT,count3gramDT),
                     function(x)dim(x)[1])
names(model.data_num) <-paste0('gram_',1:3)


# 1gram - discount - GT 
gtfunc <- function(r,ngram=1){ #GT reads
    ifelse(r<10,(r+1)*Nr_gram[[ngram]][r+1]/Nr_gram[[ngram]][r],r)
}
system.time(count1gramDT[,p_gt:= gtfunc(N)/sum(N)])

# 2gram - p_gt(w2|w1)
system.time(count2gramDT[,N_gt:= gtfunc(N,ngram = 2)])
count2gramDT[,N_t:=sum(N),by=w1]
count2gramDT[,p_gt:=N_gt/N_t]

# 3gram - p_gt(w3|w1,w2)
system.time(count3gramDT[,N_gt:= gtfunc(N,ngram = 3)])
count3gramDT[,N_t:=sum(N),by=.(w1,w2)]
head(count3gramDT)
count3gramDT[,p_gt:=N_gt/N_t]


# a 
tmpDT <- count2gramDT[,.(a=1-sum(p_gt)),by=w1]
count1gramDT$a <- tmpDT$a
tmpDT <- count3gramDT[,.(a=1-sum(p_gt)),by=.(w1,w2)]
count2gramDT$a <- tmpDT$a

#########
# models
model.1gram <- count1gramDT[,.(p_gt_log10=log10(p_gt),w1,a_log10=log10(a))]
model.2gram <- count2gramDT[,.(p_gt_log10=log10(p_gt),w1,w2,a_log10=log10(a))]
model.3gram <- count3gramDT[,.(p_gt_log10=log10(p_gt),w1,w2,w3)]
save(list=c("model.data_num","model.1gram","model.2gram","model.3gram"),file="model_ngram.RData")


