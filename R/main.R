# Clear current environment
rm(list = ls())

# Clear current console
cat("\014")  # ctrl+L

#importing functions.R file.
source("R/functions.R")


IP <- "http://31.7.194.205:8888"
getRamChart(IP)
getStepChart(IP)



#build("~/Desktop/Casper-validator-metrics-charts")

