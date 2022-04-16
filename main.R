# Clear current environment
rm(list = ls()) 

# Clear current console
cat("\014")  # ctrl+L


library(httr)
result <- GET("http://65.21.235.219:8888/metrics")
