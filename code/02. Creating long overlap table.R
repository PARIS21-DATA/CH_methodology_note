df_overlap_final <- read_rds("data/intermediate/80.2 temp norway overlap.rds")
names(df_overlap_final) 


df_overlap_final_norway <- df_overlap_final %>% 
  select(1:7 ) %>% 
  unique
names(df_overlap_final_norway)= names(df_overlap_final)[c( 1, 2, 9:13)] 


df_overlap_final_long <-  df_overlap_final_norway %>% 
  mutate(ch_name = "Norway") %>% 
  mutate(norway_project_number = projectnumber) %>%
  rbind((df_overlap_final %>% select(1:3, 8:13)))  %>% 
  ungroup() %>% 
  arrange(# sectorcode, isocode,  
          norway_project_number, ch_name != "Norway", 
          desc(usd_commitment_defl)) 


vec_norway_project <- df_overlap_final_long %>% 
  group_by(norway_project_number) %>% 
  mutate(rnk = row_number()) %>% 
  select(norway_project_number, rnk) %>% 
  ungroup() %>% 
  mutate(rownum = row_number()) %>% 
  filter(rnk ==1 ) %>% 
  .$rownum

names(df_overlap_final_long)
df_overlap_final_long_print <- df_overlap_final_long %>% 
  group_by(norway_project_number) %>% 
  mutate(isocode = ifelse(row_number() == 1, isocode, "")) %>% 
  ungroup() %>%
  mutate(usd_commitment_defl = round(usd_commitment_defl/1000)) %>% 
  select(-sectorcode, 
         -norway_project_number) %>%
  rename(Recipient = isocode, 
         ID = projectnumber, 
         `Commitment_($ thousand)` = usd_commitment_defl,  
         Project_name = projecttitle, 
         Commitment_year = commitmentdate, 
         End_date = completiondate,
         Donor = ch_name) %>% 
  select(Recipient, 
         Commitment_year, 
         Donor, Project_name, 
         `Commitment_($ thousand)`, 
         End_date, 
         ID)
df_overlap_final_long %>% 
  saveRDS("data/intermediate/80.3 temp Norway overlaps long.rds")

df_overlap_final_long_print %>% 
  saveRDS("data/intermediate/80.3 temp Norway overlaps long print.rds")


vec_norway_project %>% 
  saveRDS("data/intermediate/80.3 temp Norway overlaps vec Norway rows.rds")
# 
# df_overlap_final_long %>% 
#   select(-sectorcode, 
#          -norway_project_number) %>% 
#   rename(Recipient = isocode, 
#          ID = projectnumber, 
#          USD_commitment = usd_commitment_defl,  
#          Project_name = projecttitle, 
#          Commitment_year = commitmentdate, 
#          End_date = completiondate,
#          Donor = ch_name) %>% 
#   select(Recipient, 
#          Commitment_year, 
#          Donor, Project_name, 
#          USD_commitment, 
#          End_date, 
#          ID) 
# 
