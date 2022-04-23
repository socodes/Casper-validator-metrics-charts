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
draw_barchart <- function(H,M,xlab_,ylab_,main_) {
  # Give the chart file a name
  png(file = paste(main_,".png",sep=""))
  
  # Plot the bar chart 
  barplot(H,names.arg=M,xlab=xlab_,ylab=ylab_,col="blue",
          main=main_)
  
  # Save the file
  dev.off()
}


IP <- "http://31.7.194.205:8888"
ips <- GET(paste(IP,"/status",sep=""))
ips_content <- fromJSON(rawToChar(ips$content), flatten=TRUE)
ip_addresses <- ips_content$peers$address

ram_vector <- c()
step_vector <- c()

error <- 0
warning <- 0

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
        error <- error + 1
        message('Caught an error!')
        print(e)
        sprintf("Total error %s",error)
      },
      warning = function(w){
        warning <- warning + 1
        message('Caught an warning!')
        print(w)
        sprintf("Total warning %s",warning)
      },
      finally = {
        sprintf("Total error %s",error)
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
  if(i < 32000000000){
    ram_below_32 <- ram_below_32 +1
  }
  else if(i < 64000000000){
    ram_below_64 <- ram_below_64 +1
  }
  else if(i < 128000000000){
    ram_below_128 <- ram_below_128 +1
  }
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




