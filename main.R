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
  
  sprintf("Total amount of RAM in validator: %s",ram)
}

#function to parse commit step time of validator.
get_step_time <- function(str) {
  step_location <- str_locate(str,'contract_runtime_latest_commit_step')
  step <- substr(str, step_location[2]+140, step_location[2]+150)
  
  sprintf("Commit step time of validator: %s",step)
}


IP <- "http://31.7.194.205:8888"
ips <- GET(paste(IP,"/status",sep=""))
ips_content <- fromJSON(rawToChar(ips$content), flatten=TRUE)
ip_addresses <- ips_content$peers$address


#get data with http request.
metrics <- GET(paste(IP,"/metrics",sep=""))
#parse content of result to char.
content <- rawToChar(metrics$content)
#take ram amount
get_ram_amount(content)
#take commit step time
get_step_time(content)











