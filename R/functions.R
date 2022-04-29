#import libraries
library(httr)
library(jsonlite)
library(devtools)
library(tidyverse)
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
#parse the ip by ':' and return the first part
parse_ip <- function(ip) {
  ip_ <- str_split(ip,":")
  return(ip_[[1]])
}
draw_barchart <- function(H,M,xlab_,ylab_,main_) {
  # Give the chart file a name
  png(file = paste(main_,".png",sep=""))

  # Plot the bar chart
  xx <- barplot(H,
          names.arg = M,
          xlab = xlab_,
          ylab = ylab_,
          col = "blue",
          main = main_,)
  # Add the text
  text(x = xx, y = H, label = H, pos = 1, cex = 1.2, col = "red")

  # Save the file
  dev.off()
}
containsOnlyNumbers = function(x) !is.na(as.numeric(x))

getRamChart = function(IP) {

  #target IP

  #add '/status' to get validators'
  ips <- GET(paste(IP,"/status",sep=""))
  #Cast to JSON.
  ips_content <- fromJSON(rawToChar(ips$content), flatten=TRUE)
  #get IP addresses of related validators
  ip_addresses <- ips_content$peers$address

  #create empty ram_vector
  ram_vector <- c()


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
      },
      #if there is an error, print the error description
      error = function(e){
        message('Caught an error!')
        print(e)
      },
      #if there is an warning, print the warning description
      warning = function(w){
        message('Caught an warning!')
        print(w)

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

  ram_draw = c(ram_below_32,ram_below_64,ram_below_128,ram_more_128)
  ram_names = c("below 32","32<x<64","64<x<128","more than 128")
  draw_barchart(ram_draw,ram_names,"RAM Amount (GB)","Number of validators","RAM Amount Chart")
}
getStepChart = function(IP) {

  #target IP

  #add '/status' to get validators'
  ips <- GET(paste(IP,"/status",sep=""))
  #Cast to JSON.
  ips_content <- fromJSON(rawToChar(ips$content), flatten=TRUE)
  #get IP addresses of related validators
  ip_addresses <- ips_content$peers$address

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

        #take commit step time
        step_vector <- append(step_vector,get_step_time(content))
      },
      #if there is an error, print the error description
      error = function(e){
        message('Caught an error!')
        print(e)
      },
      #if there is an warning, print the warning description
      warning = function(w){
        message('Caught an warning!')
        print(w)

      }
    )
  }

  step_below_6 = 0
  step_below_12 = 0
  step_below_24 = 0
  step_below_32 = 0
  step_below_48 = 0
  step_more_48 = 0
  na <- 0
  #divide and count the step times
  for (i in step_vector) {

    #be sure that value is not na
    if(!is.na(i)){
      if(containsOnlyNumbers(i)){
        i <- as.numeric(i)
        #count step time < 6
        if(i <= 6){
          step_below_6 <- step_below_6 +1

        }
        #count  6 < step time < 12
        else if(i>6 & i <= 12){
          step_below_12 <- step_below_12 +1

        }
        #count  12 < step time < 24
        else if(i>12 & i <= 24){
          step_below_24 <- step_below_24+1

        }
        #count  12 < step time < 24
        else if(i>24 & i <= 32){
          step_below_32 <- step_below_32+1

        }
        #count  24 < step time < 48
        else if(i>24 & i <= 48){
          step_below_48 <- step_below_48+1

        }
        #count step time > 48
        else if(i>=48){
          step_more_48 <- step_more_48+1
        }
      }
      else{
        #print(i)
      }
    }
    else{
      na <- na+1
    }
  }

  #prep data for visualization
  step_draw = c(step_below_6,step_below_12,step_below_24,step_below_32,step_below_48,step_more_48)
  step_names = c("below 6"," 6<x<12","12<x<24","24<x<32","32<x<48","x>48")

  #draw barcharts
  draw_barchart(step_draw,step_names,"Step time (sn)","Number of validators","Step Time Chart")
}
