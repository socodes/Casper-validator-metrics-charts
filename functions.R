
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
  barplot(H,names.arg=M,xlab=xlab_,ylab=ylab_,col="blue",
          main=main_)
  
  # Save the file
  dev.off()
}
