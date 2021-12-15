library(tidyverse)
library(jsonlite)
library(janitor)
library(data.table)

df.all <- jsonlite::fromJSON("https://raw.githubusercontent.com/hodcroftlab/covariants/master/web/data/perCountryData.json", flatten=T)
### pul names
nmz<-df.all$regions$distributions[[2]][,1]
### pull data and add name
df <- lapply(1:length(nmz), function(x) df.all$regions$distributions[[2]][x,]$distribution[[1]])
names(df) <- nmz

### get n dates for each state since they are different
ndates <- sapply(1:length(nmz), function(x) nrow(df[[x]]))
### create single DF from list above
df <- data.table::rbindlist(df, fill=T)
### add state as column 
df$state <- rep(nmz, times=ndates)

### clean names
names(df) <- sub("cluster.counts.", "variant_", names(df))

df %>%
  janitor::clean_names() -> df



grep("*omicron*", names(df))
View(df[,c(1,27)])
