# encoding = 'utf8'
library("xml2")
library("rvest")
library("dplyr")
library("stringr")

JJNovelCrawl = function(url, page, enconding = 'GBK', label = ''){
  # Function for crawl novel information from search result page of JJ(jin jiang wen xue cheng)
  ## url: char; url for crawl
  ## page: int; maximum number of page
  ## encoding: set the enconding for page to be crawled
  ## label: char; label used for search

  # vessel for contain crawl result
  writer_final <- data.frame()

  # crawl each page and extract needed element by css selector
  for(i in 1:pagenum){
    web <- read_html(str_c(url, i), encoding=encoding)
    
    writer_name <- web  %>%  html_nodes("td:nth-child(1) a")  %>%  html_text()
    writer_name <- gsub("\n", "", writer_name)
    writer_name <- gsub(" ", "", writer_name)
    writer_url <- web  %>%  html_nodes("td:nth-child(1) a") %>% html_attr('href')
    writer_url <- str_c("http://www.jjwxc.net/", writer_url)
    novel_name <- web %>% html_nodes("td:nth-child(2) a") %>% html_text()
    novel_name <- gsub("\n", "", novel_name)
    novel_name <- gsub(" ", "", novel_name)
    novel_url <- web %>% html_nodes("td:nth-child(2) a") %>% html_attr('href')
    novel_url <- str_c("http://www.jjwxc.net/", novel_url)
    novel_type <- web %>% html_nodes("td:nth-child(3)") %>% html_text()
    novel_type <- novel_type[-1]
    novel_type <- gsub("\n", "", novel_type)
    novel_type <- gsub(" ", "", novel_type)
    novel_style <- web %>% html_nodes("td:nth-child(4)") %>% html_text()
    novel_style <- gsub("\n", "", novel_style)
    novel_style <- gsub(" ", "", novel_style)
    novel_style <- novel_style[-1]
    novel_status <- web %>% html_nodes("td:nth-child(5)") %>% html_text()
    novel_status <- gsub("\n", "", novel_status)
    novel_status <- gsub(" ", "", novel_status)
    novel_word_count <- web %>% html_nodes("td:nth-child(6)") %>% html_text()
    novel_word_count <- novel_word_count[-1]
    novel_word_count <- as.numeric(novel_word_count)
    novel_score <- web %>% html_nodes("td:nth-child(7)") %>% html_text()
    novel_score <- as.numeric(novel_score)
    novel_score <- novel_score[-1]
    novel_release_count <- web %>% html_nodes("td:nth-child(8)") %>% html_text()
    novel_release_count <-  novel_release_count[-1]
    novel_release_count <- as.POSIXlt(novel_release_count, format="%Y-%m-%d %H:%M:%S")
    writer_data <- data.frame(writer_name, writer_url, novel_name, novel_url, novel_type, novel_style, novel_status, novel_word_count, novel_score, novel_release_count)
    writer_final <- rbind(writer_final, writer_data) 
  }

  # remove duplicated rows and return the final result
  writer_final <- writer_final[!duplicated(writer_final$novel_name),  ]
  write_final$label = label
  return(writer_final)
}

## 穿越+清穿
through=JjwxcNovel("http://www.jjwxc.net/bookbase.php?fw0=0&fbsj=3&ycx0=0&xx0=0&mainview0=0&sd0=0&lx0=0&fg0=0&bq60=60&bq18=18&sortType=0&isfinish=0&collectiontypes=ors&searchkeywords=&page=", 2190)
again=JjwxcNovel("http://www.jjwxc.net/bookbase.php?fw0=0&fbsj=0&ycx0=0&xx0=0&mainview0=0&sd0=0&lx0=0&fg0=0&bq75=75&sortType=0&isfinish=0&collectiontypes=ors&searchkeywords=&page=", 590)
write.csv(through,file="C:\\Users\\Administrator\\Desktop\\实习\\jjwxc_novel_穿越.csv")
write.csv(again,file="C:\\Users\\Administrator\\Desktop\\实习\\jjwxc_novel_重生.csv")

