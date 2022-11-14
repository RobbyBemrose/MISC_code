#get_col_names.R
#Robby Bemrose
#Date: 2020-09-29
#Description:
# 1. select and copy .csv files in dir;
# 2. read each file and keep only unique records;
# 3. stack each data frame;
# 4. write output to .csv;


#install packages from local
install.packages(
  pkgs = c("dplyr"),
  repos = "file:////...");

#R package
library(dplyr)

#set working dir
setwd("//...")

#generate list of files with .csv as extension,
tmp_lst = list.files(pattern = "*.csv")

#empty data frame to stack data from each .csv
dat_out = data.frame()

#function to add row 1 as header
header.true = function(x) {
  names(x) = as.character(unlist(x[1,]))
  x[1,]
}

#for loop:
#1. read each .csv;
#2. call header.true function;
#3. add source VAR;
#4. stack each data frame using dplyr::bind_rows for missing cols;

for(i in 1:length(tmp_lst))
{
  dat = read.csv(file = tmp_lst[i], encoding = "UTF-8", stringsAsFactors = FALSE, sep = ",", header = TRUE, nrows=0)
  a = data.frame(t(colnames(dat)))
  a = header.true(a)
  a$source = tmp_lst[i]
  dat_out = dplyr::bind_rows(dat_out,a)
}

#write header data to .csv
dat_out$retailer = retailer
write.csv(dat_out,paste0(retailer,"_columns",".csv",sep=""))