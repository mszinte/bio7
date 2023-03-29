
#library("InformationValue")

library(ggplot2)
library(dplyr)
library(tidyverse)
library(data.table)


args <- commandArgs(trailingOnly = TRUE)
subject_number = as.character(args[1])
session_number = as.character(args[2])
subject_type = as.character(args[3]) 
task_id = as.character(args[4])
wd = as.character(args[5])
rawsubsessdir = as.character(args[6])

## Uncomment for online testing 

#subject_number = "8761"
#session_number = "02"
#subject_type = "P"
#task_id = "faceloc"
#wd = "/Users/penny/disks/meso_shared/bio7/derivatives/R/beh/faceloc"
#rawsubsessdir = "/Users/penny/disks/meso_shared/bio7/sourcedata/beh/faceloc/sub-8761/ses-02"


setwd(wd)

######### DATA ORGANISATION TASK AND REST #####################
task_data <- read.csv2(paste0(rawsubsessdir,"/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_data.csv"),header=TRUE,sep=",",na.strings = "NaN")
task_design <- read.csv2(paste0(rawsubsessdir,"/experiment2_task_design.csv"),header=TRUE,sep=",",na.strings = "NaN")

task <- cbind(task_design, task_data)

#checking for repeated columns, normally just trialnumber.. 
duplicated_names <- duplicated(colnames(task))
task <- task[!duplicated_names]

task <- task %>% mutate_at(c(1:5,18:19,26:27,31:45), as.character)
task <- task %>% mutate_at(c(1:5,18:19,26:27,31:45), as.numeric)
task <- task %>% mutate_at(c(12,14,16,20,22,23), as.factor)


task <- replace(task, task=='', NA)


######### CREATING JOINT DF TASK-REST FOR ONSETS TSV ########

# Creating grouping factor for each rest or task dataframe

df_bio7 <- task
df_bio7_ord <- df_bio7[order(df_bio7$onset_trial),]
df_bio7_ord <- cbind(subject_no = rep(subject_number,nrow(df_bio7_ord)),df_bio7_ord)
df_bio7_ord <- cbind(subject_type = rep(subject_type,nrow(df_bio7_ord)),df_bio7_ord)

df_bio7_ord$trial_type <- df_bio7_ord$target_emotion

onset_cols <- c("onset","duration","trial_type","duration_isi")
onsets_tsv <- data.frame(matrix(NA,ncol=length(onset_cols),3))
colnames(onsets_tsv) <- onset_cols

onsets_tsv$onset <- na.omit(df_bio7_ord$onset_block)-na.omit(df_bio7_ord$onset_run[1])
onsets_tsv$duration <- (na.omit(df_bio7_ord$offset_block)-na.omit(df_bio7_ord$onset_block))

blockoffsets <- na.omit(df_bio7_ord$offset_block)
blockonsets <- na.omit(df_bio7_ord$onset_block)

onsets_tsv$duration_isi[1] <- (blockonsets[2]-blockoffsets[1])
onsets_tsv$duration_isi[2] <- (blockonsets[3]-blockoffsets[2])
onsets_tsv$duration_isi[3] <- (na.omit(df_bio7_ord$offset_run)-blockoffsets[3])

onsets_tsv$trial_type <- levels(df_bio7$target_emotion)

df.tmp <- onsets_tsv

write_tsv(df.tmp,paste0("events/sub-", subject_number,"_ses-",session_number,"_task-",task_id,"_run-01_events.tsv"))

# Saving subjects dataframe for task, rest, both
write.csv(df.tmp,paste0("dataframes/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_complete_dataframe.csv"))
