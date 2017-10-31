BuildQuery = function(tbl_name, df, con, condition=NULL){
    # Function for build and insert query to write the crawled date into mysql db row by row
    ## tbl_name: string; target table name
    ## df: data.frame; the vessel contanins the crawled data
    ## con: the mysql connection cursor
    ## condition: insert condition settle after WHERE
    print("Insert task start!")
    if(condition == NULL){
        vallist = colnames(df)
        for(i in 1:nrow(df)){
            valuelist = df[i, ]
            query = str_c("INSERT INTO ", tbl_name, "(", vallist, ")", "VALUES(", valuelist, ");")
            dbSendQuery(con,query) 
        }
    } else {
        vallist = colnames(df)
        for(i in 1:nrow(df)){
            valuelist = df[i, ]
            query = str_c("INSERT INTO ", tbl_name, "(", vallist, ")", "VALUES(", valuelist, ") WHERE", condition, ";")
            dbSendQuery(con,query)        
        }
    print("Insert task done!")   
    }
}    