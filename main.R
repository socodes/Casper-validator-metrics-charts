# Clear current environment
rm(list = ls()) 

# Clear current console
cat("\014")  # ctrl+L

#import libraries
library(httr)

#get data with http request.
result <- GET("http://65.21.235.219:8888/metrics")
content <- rawToChar(result$content)
content
