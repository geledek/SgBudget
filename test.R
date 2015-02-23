# Reference at http://onepager.togaware.com/TextMiningO.pdf
require(tm)
require(wordcloud)
require(SnowballC)
require(slam)
require(RColorBrewer)

# Import documents
setwd("~/Workspaces//SgBudget/2015")
budgets.corpus <- Corpus(DirSource("."), readerControl=list(reader=readPDF))

# declare stopwords besides the usual ones
ownStopwords <- c("will", "year", "years", "also")

# Transformations
budgets.corpus <- tm_map(budgets.corpus,
                   function(x) iconv(x, to='UTF-8-MAC', sub='byte'),
                   mc.cores=1)
budgets.corpus <- tm_map(budgets.corpus, tolower)
budgets.corpus <- tm_map(budgets.corpus, removeNumbers)
budgets.corpus <- tm_map(budgets.corpus, removePunctuation)

# remove stopwords
budgets.corpus <- tm_map(budgets.corpus, removeWords, stopwords("english"))
budgets.corpus <- tm_map(budgets.corpus, removeWords, ownStopwords)

# remove whitespace
budgets.corpus <- tm_map(budgets.corpus, stripWhitespace)

# specific transformations
budgets.corpus <- tm_map(budgets.corpus, toString, "sme","SME")
budgets.corpus <- tm_map(budgets.corpus, toString, "cpf","CPF")
budgets.corpus <- tm_map(budgets.corpus, toString, "gst","GST")
budgets.corpus <- tm_map(budgets.corpus, toString, "ite","ITE")

# stemming
budgets.corpus <- tm_map(budgets.corpus, stemDocument)

# quick fix for some stubborn error
budgets.corpus <- tm_map(budgets.corpus, PlainTextDocument)

# create a document term matrix
dtm <- DocumentTermMatrix(budgets.corpus)

# create a term document matrix
tdm <- TermDocumentMatrix(budgets.corpus)

# exploring the document ter matrix
freq <- sort(colSums(as.matrix(dtm), decreasing=TRUE)

# draw wordcloud


set.seed(12)
color <- brewer.pal(8, "Dark2")

png("../wordcloud.png", width=1280,height=800)

wordcloud(names(freq), freq, min.freq=12, 
          rot.per=0.15, colors=color)
dev.off()
