
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
#task_id = "faces"
#wd = "/Users/penny/disks/meso_shared/bio7/derivatives/R/beh/faces"
#rawsubsessdir = "/Users/penny/disks/meso_shared/bio7/sourcedata/beh/faces/sub-8761/ses-02"


setwd(wd)

######### DATA ORGANISATION TASK AND REST #####################
task_data <- read.csv2(paste0(rawsubsessdir,"/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_data.csv"),header=TRUE,sep=",",na.strings = "NaN")
task_design <- read.csv2(paste0(rawsubsessdir,"/experiment1_task_design.csv"),header=TRUE,sep=",",na.strings = "NaN")
rest_data <- read.csv2(paste0(rawsubsessdir,"/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_rest_data.csv"),header=TRUE,sep=",",na.strings = "NaN")
rest_design <- read.csv2(paste0(rawsubsessdir,"/experiment1_rest_design.csv"),header=TRUE,sep=",",na.strings = "NaN")

task <- cbind(task_design, task_data)
rest <- cbind(rest_design, rest_data)

#checking for repeated columns, normally just trialnumber.. 
duplicated_names <- duplicated(colnames(task))
task <- task[!duplicated_names]

task <- task %>% mutate_at(c(1:5,18:19,26:27,33:34,36:40,42,45:69), as.character)
task <- task %>% mutate_at(c(1:5,18:19,26:27,33:34,36:40,42,45:69), as.numeric)
task <- task %>% mutate_at(c(6:17,20:25,28:32,35,41,43:45), as.factor)

task <- replace(task, task=='', NA)
task$response_correct <- ifelse(task$target_emotion_ref != task$response_key,1,0)

#checking for repeated columns, normally just trialnumber.. 
duplicated_names_rest <- duplicated(colnames(rest))
rest <- rest[!duplicated_names_rest]

rest <- replace(rest, rest=='', NA)

# checking if task and rest have same data columns

col_task <- colnames(task)
col_rest <- colnames(rest)

colsin_both <- col_rest[col_rest %in% col_task]
colsin_rest <- col_rest[!col_rest %in% col_task]
colsin_task <- col_task[!col_task %in% col_rest]


# replacing columns only in rest with equivalent in task - manual rename

colsin_rest_rename <- str_replace_all(colsin_rest, "image", "target")
setnames(rest, old = colsin_rest, new = colsin_rest_rename)

col_task <- colnames(task)
col_rest <- colnames(rest)

colsin_both <- col_rest[col_rest %in% col_task]
colsin_rest <- col_rest[!col_rest %in% col_task]
colsin_task <- col_task[!col_task %in% col_rest]


# creating columns only in task in rest - manual, then rename based on task df 

colsin_rest_mutate = str_replace_all(colsin_task, "mask", "target")
rest <- cbind(rest, rest[,colsin_rest_mutate])
colnames(rest)[(length(rest)-length(colsin_rest_mutate)+1):length(rest)] <- colsin_task


# final check 

col_task <- colnames(task)
col_rest <- colnames(rest)

colsin_both <- col_rest[col_rest %in% col_task]
colsin_rest <- col_rest[!col_rest %in% col_task]
colsin_task <- col_task[!col_task %in% col_rest]


# reorder rest dataframe as task dataframe

rest <- rest[,c(col_task)]

rest <- rest %>% mutate_at(c(1:5,18:19,26:27,33:34,36:40,42,45:69), as.character)
rest <- rest %>% mutate_at(c(1:5,18:19,26:27,33:34,36:40,42,45:69), as.numeric)
rest <- rest %>% mutate_at(c(6:17,20:25,28:32,35,41,43:45), as.factor)


######### CREATING JOINT DF TASK-REST FOR ONSETS TSV ########

# Creating grouping factor for each rest or task dataframe

rest <- cbind(task_type = rep("REST",nrow(rest)),rest) 
task <- cbind(task_type = rep("TASK",nrow(task)),task) 


df_bio7 <- rbind(task,rest)
df_bio7_ord <- df_bio7[order(df_bio7$onset_trial),]
df_bio7_ord <- cbind(trial_number_combi = 1:nrow(df_bio7_ord), df_bio7_ord)
df_bio7_ord <- cbind(subject_no = rep(subject_number,nrow(df_bio7_ord)),df_bio7_ord)
df_bio7_ord <- cbind(subject_type = rep(subject_type,nrow(df_bio7_ord)),df_bio7_ord)

trial_type <- data.frame(matrix(NA,ncol=1,nrow=nrow(df_bio7_ord)))
con_uncon <- data.frame(matrix(NA,ncol=1,nrow=nrow(df_bio7_ord)))
target_emo <- data.frame(matrix(NA,ncol=1,nrow=nrow(df_bio7_ord)))

for (i in 1:nrow(df_bio7_ord)) {

if ((df_bio7_ord$target_emotion[i] == "happy") & (as.numeric(df_bio7_ord$soa_ref[i]) < mean(as.numeric(df_bio7_ord$soa_ref)))) {
  trial_type[i,1] = "UnconHappy"
  con_uncon[i,1] = "Uncon"
  target_emo[i,1] = "Happy"
  }

if ((df_bio7_ord$target_emotion[i] == "happy") & (as.numeric(df_bio7_ord$soa_ref[i]) > mean(as.numeric(df_bio7_ord$soa_ref)))) {
  trial_type[i,1] = "ConHappy"
  con_uncon[i,1] = "Con"
  target_emo[i,1] = "Happy"
  }

if ((df_bio7_ord$target_emotion[i] == "fear") & (as.numeric(df_bio7_ord$soa_ref[i]) < mean(as.numeric(df_bio7_ord$soa_ref)))) {
  trial_type[i,1] = "UnconFear"
  con_uncon[i,1] = "Uncon"
  target_emo[i,1] = "Fear"
  }

if ((df_bio7_ord$target_emotion[i] == "fear") & (as.numeric(df_bio7_ord$soa_ref[i]) > mean(as.numeric(df_bio7_ord$soa_ref)))) {
  trial_type[i,1] = "ConFear"
  con_uncon[i,1] = "Con"
  target_emo[i,1] = "Fear"
  }

if ((df_bio7_ord$target_emotion[i] == "neutral") & (as.numeric(df_bio7_ord$soa_ref[i]) < mean(as.numeric(df_bio7_ord$soa_ref)))) {
  trial_type[i,1] = "UnconNeutr"
  con_uncon[i,1] = "Uncon"
  target_emo[i,1] = "Neutr"
  }

if ((df_bio7_ord$target_emotion[i] == "neutral") & (as.numeric(df_bio7_ord$soa_ref[i]) > mean(as.numeric(df_bio7_ord$soa_ref)))) {
  trial_type[i,1] = "ConNeutr"
  con_uncon[i,1] = "Con"
  target_emo[i,1] = "Neutr"
  }
}

df_bio7_ord$trial_type <- trial_type[,1]
df_bio7_ord$con_uncon <- con_uncon[,1]
df_bio7_ord$target_emo <- target_emo[,1]


# Saving subjects dataframe for task, rest, both
write.csv(task,paste0("dataframes/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_task_dataframe.csv"))
write.csv(rest,paste0("dataframes/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_rest_dataframe.csv"))
write.csv(df_bio7_ord,paste0("dataframes/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_complete_dataframe.csv"))


# Creating events.tsvs, Dividing dataframe according to run number

X<-split(df_bio7_ord, df_bio7_ord$run_number)

runs <- as.numeric(max(levels(df_bio7_ord$run_number)))
onset_cols <- c("onset","duration","trial_type","response_time","response_correct","duration_isi", "stim_file", "trial_type_consc", "trial_type_emo")
onsets_tsv <- data.frame(matrix(NA,ncol=length(onset_cols),nrow=nrow(X[[1]])))
colnames(onsets_tsv) <- onset_cols

df.tmp <- list(onsets_tsv,onsets_tsv,onsets_tsv,onsets_tsv)


for (i in 1:runs) {
  tmp <- X[[i]]
  df.tmp[[i]][["onset"]] <- tmp[["onset_target"]] - tmp[["onset_run"]][1]
  df.tmp[[i]][["duration"]] <- tmp[["onset_mask"]] - tmp[["onset_target"]]
  df.tmp[[i]][["trial_type"]] <- tmp[["trial_type"]]
  df.tmp[[i]][["response_time"]] <- tmp[["duration_target"]] + tmp[["duration_mask"]] + tmp[["reaction_time"]]
  df.tmp[[i]][["response_correct"]] <- tmp[["response_correct"]]
  df.tmp[[i]][["stim_file"]] <- tmp[["target_imagename"]]
  df.tmp[[i]][["trial_type_consc"]] <- tmp[["con_uncon"]]
  df.tmp[[i]][["trial_type_emo"]] <- tmp[["target_emo"]]
  
  for (j in 1:(nrow(tmp)-1)) {
    
    df.tmp[[i]][["duration_isi"]][j] <- df.tmp[[i]][["onset"]][j+1] - df.tmp[[i]][["onset"]][j] - df.tmp[[i]][["duration"]][j]
    # onset j+1 -	onset j	- duration j
    
  } 
  write_tsv(df.tmp[[i]],paste0("events/sub-", subject_number,"_ses-",session_number,"_task-",task_id,"_run-0",i,"_events.tsv"))
}


###### PRELIMINARY TASK CALCULATIONS AND GRAPHS - RESPONSES AND SOA ##############

task %>% 
  group_by(soa_secs) %>% 
  summarise(mean = mean(response_correct, na.rm = TRUE)) %>% 
  ggplot(.,aes(x=soa_secs,y=mean)) +
  geom_point() +
  geom_smooth()
ggsave(paste0("figures/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_responsecorrect-soa.tiff"),width = 6, height = 4)

task %>% 
  group_by(soa_secs, target_emotion) %>% 
  summarise(mean = mean(response_correct, na.rm = TRUE)) %>% 
  ggplot(.,aes(x=soa_secs,y=mean, col = factor(target_emotion))) +
  geom_point() +
  geom_smooth()
ggsave(paste0("figures/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_responsecorrect-soa_by_emotion.tiff"),width = 6, height = 4)

task %>% 
  group_by(soa_secs, location_name) %>% 
  summarise(mean = mean(response_correct, na.rm = TRUE)) %>% 
  ggplot(.,aes(x=soa_secs,y=mean, col = location_name)) +
  geom_point() +
  geom_smooth()
ggsave(paste0("figures/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_responsecorrect-soa_by_location.tiff"),width = 6, height = 4)

task %>% 
  group_by(soa_secs, response_key_name) %>% 
  summarise(mean = mean(response_correct, na.rm = TRUE)) %>% 
  ggplot(.,aes(x=soa_secs,y=mean, col = response_key_name)) +
  geom_point() +
  geom_smooth()
ggsave(paste0("figures/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_responsecorrect-soa_by_responsekey.tiff"),width = 6, height = 4)

ggplot(task, aes(x=as.factor(round(soa_secs,3)), y=response_correct, fill=response_key_name)) + 
  geom_bar(position="fill", stat="identity", na.rm = TRUE) +
  xlab("SOA (seconds)") +
  ylab("% Response Correct") + 
  labs(fill = "Response Key")
  #geom_jitter(height = 0.1, na.rm = TRUE)
ggsave(paste0("figures/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_responsecorrect-soa_by_responsekey_bar.tiff"),width = 6, height = 4)


ggplot(task, aes(x=as.factor(round(soa_secs,3)), fill=response_key_name)) + 
  geom_bar(position="fill",na.rm = TRUE) +
  xlab("SOA (seconds)") +
  ylab("% Frequency") + 
  labs(fill = "Response Key")
ggsave(paste0("figures/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_soa_by_responsekeyfreq_bar.tiff"),width = 6, height = 4)

ggplot(task, aes(x=as.factor(round(soa_secs,3)), fill=target_emotion)) + 
  geom_bar(position="fill",na.rm = TRUE) +
  xlab("SOA (seconds)") +
  ylab("% Frequency") + 
  labs(fill = "Target Emotion")
ggsave(paste0("figures/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_soa_by_target_emotionfreq_bar.tiff"),width = 6, height = 4)

ggplot(task, aes(x=as.factor(round(soa_secs,3)), fill=location_name)) + 
  geom_bar(position="fill",na.rm = TRUE) +
  xlab("SOA (seconds)") +
  ylab("% Frequency") + 
  labs(fill = "Target Location")
ggsave(paste0("figures/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_soa_by_locationfreq_bar.tiff"),width = 6, height = 4)

ggplot(task, aes(x=as.factor(round(soa_secs,3)), fill=as.factor(response_correct))) + 
  geom_bar(position="fill",na.rm = TRUE) +
  scale_fill_discrete(labels=c("Incorrect", "Correct", "NA")) +
  xlab("SOA (seconds)") +
  ylab("% Frequency") + 
  labs(fill = "Response Correct")
ggsave(paste0("figures/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_soa_by_response_correctfreq_bar.tiff"),width = 6, height = 4)

ggplot(task, aes(x=location_name, y=response_correct, fill=response_key_name)) + 
  geom_bar(position="fill", stat="identity", na.rm = TRUE) +
  xlab("Target Location") +
  ylab("% Response Correct") + 
  labs(fill = "Response Key")
#geom_jitter(height = 0.1, na.rm = TRUE)
ggsave(paste0("figures/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_responsecorrect-vs-responselocation_bar.tiff"),width = 6, height = 4)

#ggplot(task, aes(x=soa_secs, y=response_key, col=response_key_name)) + 
#  geom_jitter(height = 0.1, na.rm = TRUE)  +
#  xlab("SOA (seconds)") +
#  ylab("Response Key") + 
#  labs(fill = "Response Key")
#ggsave(paste0("figures/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_responsekey-groupyby-soa.tiff"),width = 6, height = 4)

ggplot(task, aes(x=location_name, y=response_key, col=response_key_name)) + 
  geom_jitter(height = 0.1, na.rm = TRUE) 
ggsave(paste0("figures/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_responsekey-location.tiff"),width = 6, height = 4)



table_responsekey <- aggregate(as.numeric(task$response_key), list(task$soa_secs), FUN=mean, na.rm = TRUE)
write.csv(table_responsekey,paste0("tables/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"__responsekey-by-soa.csv"))
table_responsecorrect <- aggregate(task$response_correct, list(task$soa_secs), FUN=mean, na.rm = TRUE)
write.csv(table_responsecorrect,paste0("tables/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_responsecorrect-by-soa.csv"))
table_location <- aggregate(as.numeric(task$location), list(task$soa_secs), FUN=mean, na.rm = TRUE)
write.csv(table_location,paste0("tables/sub-",subject_number,"_ses-",session_number,"_task-",task_id,"_location-by-soa.csv"))
