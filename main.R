# Clear current environment
rm(list = ls()) 

# Clear current console
cat("\014")  # ctrl+L

#importing functions.R file.
source("functions.R")

#import libraries
library(httr)
library(tidyverse)
library(shiny)
library(jsonlite)
library(devtools)


#target IP
IP <- "http://31.7.194.205:8888"
#add '/status' to get validators'
ips <- GET(paste(IP,"/status",sep=""))
#Cast to JSON.
ips_content <- fromJSON(rawToChar(ips$content), flatten=TRUE)
#get IP addresses of related validators
ip_addresses <- ips_content$peers$address

#create empty ram_vector
ram_vector <- c()
#create empty step_vector
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
      #if there is an error, print the error description
      error = function(e){
        message('Caught an error!')
        print(e)
        sprintf("Total error %s",error)
      },
      #if there is an warning, print the warning description
      warning = function(w){
        message('Caught an warning!')
        print(w)
        sprintf("Total warning %s",warning)
      }
    )
}

ram_below_32 = 0
ram_below_64 = 0
ram_below_128 = 0
ram_more_128 = 0
#divide and count the ram amounts
for (i in ram_vector) {
  #count ram amount < 32 GB
  if(i < 32000000000){
    ram_below_32 <- ram_below_32 +1
  }
  #count ram 32 GB< amount < 64 GB
  else if(i < 64000000000){
    ram_below_64 <- ram_below_64 +1
  }
  #count ram 64 GB< amount < 128 GB
  else if(i < 128000000000){
    ram_below_128 <- ram_below_128 +1
  }
  #count ram  amount > 128 GB
  else{
    ram_more_128 <- ram_more_128 +1
  }
}
step_below_6 = 0
step_below_12 = 0
step_below_24 = 0
step_below_48 = 0
step_more_48 = 0
#divide and count the step times 
for (i in step_vector) {
  if(!is.na(i)){
    i <- as.numeric(i)

    if(i < 6){
      step_below_6 <- step_below_6 +1
    }
    else if(i>6 & i < 12){
      step_below_12 <- step_below_12 +1
    }
    else if(i>12 && i < 24){
      step_below_24 <- step_below_24+1
    }
    else if(i>24 & i < 48){
      step_below_48 <- step_below_48+1
    }
    else if(i>48){
      step_more_48 <- step_more_48+1
    }
  }
}
#prep data for visualization
step_draw = c(step_below_6,step_below_12,step_below_24,step_below_48,step_more_48)
step_names = c("below 6","below 12","below 24","below 48","more 48")

ram_draw = c(ram_below_32,ram_below_64,ram_below_128,ram_more_128)
ram_names = c("below 32","below 64","below 128","more 128")

#draw barcharts
draw_barchart(step_draw,step_names,"Number of validators","Step time (sn)","Step Time Chart")
draw_barchart(ram_draw,ram_names,"Number of validators","RAM Amount (GB)","RAM Amount Chart")


build("~/Desktop/Casper-rpc-call")

