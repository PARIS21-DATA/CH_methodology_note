df_crs_original <- read_rds("~/dropbox/paris21/R/PRESS/Data/Intermediate/crs01_1_utf8_full.rds")
df_press <- read_rds("data/intermediate/Clearinghouse_fulldata.rds")

df_norway_dac_priorirty <- df_crs_original %>% 
  filter(donorname == "Norway", 
         year > 2017) %>% 
  group_by(recipientname) %>% 
  summarise(usd_disbursement_defl = sum(usd_disbursement_defl, na.rm = T)) %>% 
  arrange(desc(usd_disbursement_defl)) %>% 
  mutate(isocode = countrycode(recipientname, "country.name", "iso3c")) 

# rm(df_crs_original)

df_crs <- df_press %>% 
  select(db_ref, ida, fs) %>% 
  right_join(df_crs)

df_norway_orphans <- df_crs %>% 
  filter(ch_name == "Norway", 
         disbursementdate > 2017) %>% 
  group_by(isocode) %>% 
  summarise(disbursement_data = sum(usd_disbursement_defl, na.rm = T)) %>% 
  full_join(df_norway_dac_priorirty) %>% 
  arrange(desc(usd_disbursement_defl)) %>% 
  filter(!is.na(isocode)) %>% 
  mutate(disbursement_data = ifelse(is.na(disbursement_data), 
                                    0, 
                                    disbursement_data)) %>% 
  mutate(datashare = disbursement_data/usd_disbursement_defl/1000000*100) %>% 
  filter(disbursement_data == 0  , 
         usd_disbursement_defl > 50)  %>% 
  rename(total_oda = usd_disbursement_defl, 
         funding_to_data = disbursement_data, 
         share_of_ODA_to_data = datashare) %>% 
  mutate(total_oda = total_oda * 1000000)

df_norway_orphans <- df_crs %>% 
  filter(isocode %in% unique(df_norway_orphans$isocode)) %>% 
  filter(disbursementdate > 2017) %>% 
  group_by(isocode) %>% 
  summarise(total_data_other_donors = sum(usd_disbursement_defl, na.rm = T)) %>% 
  right_join(df_norway_orphans)



df_orphan_oda <- df_crs_original %>% 
  filter(year > 2017) %>% 
  select(recipientname, usd_disbursement, donorname) %>% 
  group_by(recipientname) %>% 
  summarise(total_oda_other_donors = sum(usd_disbursement, na.rm = T)) %>% 
  mutate(isocode = countrycode(recipientname, "country.name", "iso3c")) %>%
  filter(!is.na(isocode))

df_norway_orphans <- df_orphan_oda %>% 
  filter(isocode %in% df_norway_orphans$isocode) %>% 
  right_join(df_norway_orphans) %>% 
  mutate(datashare = total_data_other_donors/total_oda_other_donors/1000000*100) %>% 
  # filter(datashare < 0.3) %>% 
  arrange(datashare)  %>% 
  inner_join(df_crs %>% filter(disbursementdate == 2020) %>% select( isocode, fs, ida) %>% unique) %>% 
  select(recipientname, total_oda, datashare, fs, ida) %>% 
  mutate(fs = ifelse(is.na(fs), 0, 1)) %>% 
  arrange(desc(ida), fs,datashare)


saveRDS(df_norway_orphans, file = "Data/intermediate/81 orphans.rds")




