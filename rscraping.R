install.packages("pdftools","reshape2")
library(pdftools)
library(reshape2)
# you can use an url or a path
pdf_url <- "https://www.oecd.org/dac/financing-sustainable-development/development-finance-standards/ODA-2021-summary.pdf"

# `pdf_text` converts it to a list
list_output <- pdftools::pdf_data(pdf_url)

# you get an element by page
length(list_output) 

page <- list_output[12][[1]]

page = subset(page,page$y<615&page$y>193)

### https://benjaminlouis-stat.fr/en/blog/2019-04-03-pdf-vs-html/

df.limits <- data.frame(c(91,174), c(175,217), c(218,254),c(255,297),c(298,327),c(328,367),c(368,405),c(406,465),c(466,471))

for (i in c(1:ncol(df.limits))){
  df.limits.sub = df.limits[,i]
  hold <- subset(page,page$x>=df.limits.sub[1]&page$x<=df.limits.sub[2])
  hold <- dcast(hold,y~x)
  hold$text <- apply(hold[,-c(1)], 1,function(i){ paste(na.omit(i), collapse = " ") })
  hold = data.frame(hold$text,hold$y)
  names(hold)=c(paste0("column_",i),"y")
  if (i==1){final_df = hold}else{final_df = merge(final_df,hold,all=T)}
}

final_df$y = NULL
write.csv(final_df,"C:/git/pdf-scraping/output/table_3a.csv")
