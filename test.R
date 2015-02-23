# Reference at http://onepager.togaware.com/TextMiningO.pdf
require(tm)
require(wordcloud)
require(SnowballC)
require(slam)
# Import documents
setwd("~/Workspaces//sg_budget_analysis_02to14/pdf/")
budgets.corpus <- Corpus(DirSource("."), readerControl=list(reader=readPDF))

# Transformations
budgets.corpus <- tm_map(budgets.corpus,
                   function(x) iconv(x, to='UTF-8-MAC', sub='byte'),
                   mc.cores=1)
budgets.corpus <- tm_map(budgets.corpus, tolower)
budgets.corpus <- tm_map(budgets.corpus, removeNumbers)
budgets.corpus <- tm_map(budgets.corpus, removePunctuation)
budgets.corpus <- tm_map(budgets.corpus, removeWords, stopwords("english"))
budgets.corpus <- tm_map(budgets.corpus, stripWhitespace)
wordcloud(budgets.corpus)

# Stemming
budgets.corpus <- tm_map(budgets.corpus, stemDocument)

set.seed(123)
wordcloud(budgets.corpus)

# Create a document term matrix
dtm <- DocumentTermMatrix(budgets.corpus,
                          control = list(weighting =
                                        function(x) weightTfIdf(x, normalize =
                                                   FALSE),
                                        stopwords = TRUE))

inspect(budgets.corpus)
