##work1.1
library(xml2)
library(rvest)
library(dplyr)
library(stringr)
library(RMySQL)


#对爬取页数进行设定并创建数据框

writer_final <- data.frame()
#guess_encoding("http://www.jjwxc.net/bookbase.php?fw0 = 0&fbsj = 3&ycx0 = 0&xx0 = 0&mainview0 = 0&sd0 = 0&lx0 = 0&fg0 = 0&collectiontypes = ors&null = 0&searchkeywords = ")

#使用for循环进行批量数据爬取（发现url的规律，写for循环语句）

for (i in 1412:2187){
  Sys.sleep(2)
  url = str_c("http://www.jjwxc.net/bookbase.php?fw0=0&fbsj=0&ycx0=0&xx0=0&mainview0=0&sd0=0&lx0=0&fg0=0&collectiontypes=ors&bq60=60&bq18=18&searchkeywords=&page=", i)
  web = read_html(url, encoding  =  "GB18030")
  #用SelectorGadget定位节点信息并爬取, 同时进行数据清洗

  writer_name <- web %>% html_nodes("td:nth-child(1) a") %>% html_text()
  writer_name = gsub("\n", "", writer_name)
  writer_name = gsub(" ", "", writer_name)
  writer_url <- web %>% html_nodes("td:nth-child(1) a") %>% html_attr('href')
  writer_url <- str_c("http://www.jjwxc.net/", writer_url)
  novel_name <- web %>% html_nodes("td:nth-child(2) a") %>% html_text()
  novel_name = gsub("\n", "", novel_name)
  novel_name = gsub(" ", "", novel_name)
  novel_url <- web %>% html_nodes("td:nth-child(2) a") %>% html_attr('href')
  novel_url <- str_c("http://www.jjwxc.net/", novel_url)
  novel_type <- web %>% html_nodes("td:nth-child(3)") %>% html_text()
  novel_type <- novel_type[-1]
  novel_type = gsub("\n", "", novel_type)
  novel_type = gsub(" ", "", novel_type)
  novel_style <- web %>% html_nodes("td:nth-child(4)") %>% html_text()
  novel_style = gsub("\n", "", novel_style)
  novel_style = gsub(" ", "", novel_style)
  novel_style = novel_style[-1]
  novel_status <- web %>% html_nodes("td:nth-child(5)") %>% html_text()
  novel_status = gsub("\n", "", novel_status)
  novel_status = gsub(" ", "", novel_status)
  novel_status = novel_status[-1]
  novel_word_count <- web %>% html_nodes("td:nth-child(6)") %>% html_text()
  novel_word_count <- novel_word_count[-1]
  novel_word_count = as.numeric(novel_word_count)
  novel_score <- web %>% html_nodes("td:nth-child(7)") %>% html_text()
  novel_score = as.numeric(novel_score)
  novel_score = novel_score[-1]
  novel_release_count <- web %>% html_nodes("td:nth-child(8)") %>% html_text()
  novel_release_count =  novel_release_count[-1]
  novel_release_count = as.POSIXlt(novel_release_count, format = "%Y-%m-%d %H:%M:%S")
  writer_data <- data.frame(writer_name, writer_url, novel_name, novel_url, novel_type, novel_style, novel_status, novel_word_count, novel_score, novel_release_count)
  writer_final <- rbind(writer_final, writer_data)
  
}

# 去重并添加label，写入表格
writer_final = writer_final[!duplicated(writer_final$novel_url),  ]
writer_final$label = '穿越'
# label = rep("穿越", dim(writer_final)[1])
# writer_final = cbind(writer_final, label)
# write.csv(writer_final, file = "C:\\Users\\Administrator\\Desktop\\实习\\jjwxc_novel_穿越.csv")

# 连接mysql数据库，并将采集结果写入库
con = dbConnect(MySQL(), host="fksad.top", port = 3306,
                user="guest", password="Guest@fksad1992",
                dbname="GuestDB")
# BuildQuery(tbl_name='jjwxc_novel_label', df=writer_final, con=con)
dbWriteTable(con, 'novel', writer_final, append = TRUE)
dbDisconnect(con)