#select_dat.R
#Robby Bemrose
#Date: 2020-09-29
#Description:
# 1. select and copy .csv files in dir;
# 2. read each file and keep only unique records;
# 3. stack each data frame;
# 4. write output to .csv;
 
#R package
library(dplyr)
 
#name of retailer
retailer = "_hm_"
 
#set working dir
setwd("//…")
 
#generate list of files with .csv as extension,
tmp_lst = list.files(pattern = "*.csv")
 
#for loop:
#1. read each .csv;
#2. add source VAR;
#3. stack each data frame using dplyr::bind_rows for missing cols;
#4. keep only unique (dplyr) using product_name and description;
 
#empty data frame to stack data from each .csv
dat_out = data.frame()
 
for(i in 1:length(tmp_lst))
{
  dat = read.csv(file = tmp_lst[i], encoding = "UTF-8", stringsAsFactors = FALSE, sep = ",")
  dat$source = tmp_lst[i]
  dat$retailer = retailer
  dat$r = nrow(dat)
  dat$unq = nrow(distinct(dat, product_name, description))
  dat$source = tmp_lst[i]
  dat = subset(dat, select = c("source","retailer","r","unq"))
  dat_out = dplyr::bind_rows(dat_out,dat)
  dat_out = dat_out %>%
    distinct(source, .keep_all = TRUE)
}
 
#substr source to create date VAR
dat_out$date = substr(dat_out$source,1,8)
#drop VAR source
dat_out[c("source")] <- list(NULL)
#write unique record data to .csv
write.csv(dat_out,paste0(retailer,"_count_rows_unique",".csv",sep = ""))
 
#R package
library(ggplot2)
 
#plot bar chart of number of records per weekly .csv
png("num_records_per_week.png", units="in", width=15, height=5, res=600)
p = ggplot(data = dat_out, aes(x=date, y=r)) +
  geom_bar(width = 0.7, stat="identity", fill = "blue") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  theme(panel.background = element_blank()) +
  theme(text = element_text(size = 8))
p
dev.off()
 
#plot bar chart of number of unique records per weekly .csv
png("num_records_unique_per_week.png", units="in", width=15, height=5, res=600)
p = ggplot(data = dat_out, aes(x=date, y=unq)) +
  geom_bar(width = 0.7, stat="identity", fill = "blue") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  theme(panel.background = element_blank()) +
  theme(text = element_text(size = 8))
p
dev.off()
