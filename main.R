# Clear current environment
rm(list = ls()) 

# Clear current console
cat("\014")  # ctrl+L

#import libraries
library(httr)
library(tidyverse)
library(shiny)
library(jsonlite)

#function to parse amount of ram of validator.
get_ram_amount <- function(str) {
  location <- str_locate(str,'total_ram_bytes')
  ram <- substr(str, location[2]+73, location[2]+83)
  
  return(ram)
}

#function to parse commit step time of validator.
get_step_time <- function(str) {
  step_location <- str_locate(str,'contract_runtime_latest_commit_step')
  step <- substr(str, step_location[2]+140, step_location[2]+150)
  
  return(step)
}

parse_ip <- function(ip) {
  ip_ <- str_split(ip,":")
  return(ip_[[1]])
}
draw_barchart <- function(data, xstring,ystring) {
  barplot(data$x_axis ~ data$y_axis, ylab = ystring, xlab = xstring,
          horiz = FALSE)
}


IP <- "http://31.7.194.205:8888"
ips <- GET(paste(IP,"/status",sep=""))
ips_content <- fromJSON(rawToChar(ips$content), flatten=TRUE)
ip_addresses <- ips_content$peers$address

ram_vector <- c()
step_vector <- c()


for (ip in ip_addresses) {
    tryCatch(
      expr = {
        ip <- parse_ip(ip)
        #get data with http request.
        metrics <- GET(paste("http://",ip[1],":8888/metrics",sep=""))
        #parse content of result to char.
        content <- rawToChar(metrics$content)
        
        #take ram amount
        ram_vector <- append(ram_vector,get_ram_amount(content))
        #take commit step time
        step_vector <- append(step_vector,get_step_time(content))
      },
      error = function(e){
        message('Caught an error!')
        print(e)
      },
      warning = function(w){
        message('Caught an warning!')
        print(w)
      }
    )
}


