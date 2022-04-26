

# Casper Validators' Metrics Charts

This package aims to visualise step time and RAM amount of Casper validators. 

## Dependencies:
- httr
- tidyverse
- shiny
- jsonlite
- devtools

## Building:

- Install devtools by typing (within R)

```
 install.packages(devtools)
```

- Then load the devtools package with
```
 library(devtools)
```
- Then, to build the package, type
```
 build()
```
This will create the PACKAGE_NAME.tar.gz file.

## Testing:

- will be updated

## Install:
To install the R package, you’d type

from R:
```
install()
```
OR

from command line:
```
R CMD INSTALL Call_1.0.0.tar.gz
````

## How to use:
- Install required R language version from https://www.r-project.org
- install required packages from command line as:
install.package(PACKAGE_NAME)
- Change current working directory to repository location.
- Run the script:
```
 Rscript main.R
```


## Sample Outputs:
![](https://raw.githubusercontent.com/socodes/Casper-validator-metrics-charts/main/RAM%20Amount%20Chart.png)
![](https://raw.githubusercontent.com/socodes/Casper-validator-metrics-charts/main/Step%20Time%20Chart.png)
