library(admiral)
library(dplyr)
library(lubridate)
library(stringr)
library(pharmaversesdtm)

# Input datasets
dm <- pharmaversesdtm::dm
vs <- pharmaversesdtm::vs
ex <- pharmaversesdtm::ex
ds <- pharmaversesdtm::ds
ae <- pharmaversesdtm::ae

# Start with DM as base ADSL
adsl <- dm

# AGEGR9 and AGEGR9N
adsl <- adsl %>%
  mutate(
    AGEGR9 = case_when(
      AGE < 18 ~ "<18",
      AGE >= 18 & AGE <= 50 ~ "18 - 50",
      AGE > 50 ~ ">50",
      TRUE ~ NA_character_
    ),
    AGEGR9N = case_when(
      AGE < 18 ~ 1L,
      AGE >= 18 & AGE <= 50 ~ 2L,
      AGE > 50 ~ 3L,
      TRUE ~ NA_integer_
    )
  )

# ITTFL
adsl <- adsl %>%
  mutate(
    ITTFL = if_else(!is.na(ARM) & ARM != "", "Y", "N")
  )

# TRTSDTM from first valid EX record
ex_valid <- ex %>%
  mutate(
    VALID_DOSE = EXDOSE > 0 | (EXDOSE == 0 & str_detect(toupper(EXTRT), "PLACEBO")),
    EXSTDT = ymd_hms(if_else(
      nchar(EXSTDTC) == 10,
      paste0(EXSTDTC, "T00:00:00"),
      EXSTDTC
    ), quiet = TRUE)
  ) %>%
  filter(VALID_DOSE, !is.na(EXSTDT))

trtstdtm <- ex_valid %>%
  group_by(USUBJID) %>%
  summarise(TRTSDTM = min(EXSTDT), .groups = "drop")

adsl <- adsl %>%
  left_join(trtstdtm, by = "USUBJID")

# ABNSBPFL from VS
abnsbp <- vs %>%
  filter(VSTESTCD == "SYSBP", VSSTRESU == "mmHg", !is.na(VSSTRESN)) %>%
  group_by(USUBJID) %>%
  summarise(
    ABNSBPFL = if_else(any(VSSTRESN < 100 | VSSTRESN >= 140), "Y", "N"),
    .groups = "drop"
  )

adsl <- adsl %>%
  left_join(abnsbp, by = "USUBJID") %>%
  mutate(ABNSBPFL = coalesce(ABNSBPFL, "N"))

# CARPOPFL from AE
carpop <- ae %>%
  mutate(AESOC_UP = toupper(AESOC)) %>%
  group_by(USUBJID) %>%
  summarise(
    CARPOPFL = if_else(any(AESOC_UP == "CARDIAC DISORDERS"), "Y", NA_character_),
    .groups = "drop"
  )

adsl <- adsl %>%
  left_join(carpop, by = "USUBJID")

# LSTALVDT components
vs_last <- vs %>%
  filter(!(is.na(VSSTRESN) & is.na(VSSTRESC))) %>%
  mutate(VSDT = ymd(substr(VSDTC, 1, 10))) %>%
  filter(!is.na(VSDT)) %>%
  group_by(USUBJID) %>%
  summarise(VS_LASTDT = max(VSDT), .groups = "drop")

ae_last <- ae %>%
  mutate(AEDT = ymd(substr(AESTDTC, 1, 10))) %>%
  filter(!is.na(AEDT)) %>%
  group_by(USUBJID) %>%
  summarise(AE_LASTDT = max(AEDT), .groups = "drop")

ds_last <- ds %>%
  mutate(DSDT = ymd(substr(DSSTDTC, 1, 10))) %>%
  filter(!is.na(DSDT)) %>%
  group_by(USUBJID) %>%
  summarise(DS_LASTDT = max(DSDT), .groups = "drop")

ex_last <- ex_valid %>%
  mutate(EXDT = as.Date(EXSTDT)) %>%
  group_by(USUBJID) %>%
  summarise(EX_LASTDT = max(EXDT), .groups = "drop")

adsl <- adsl %>%
  left_join(vs_last, by = "USUBJID") %>%
  left_join(ae_last, by = "USUBJID") %>%
  left_join(ds_last, by = "USUBJID") %>%
  left_join(ex_last, by = "USUBJID") %>%
  rowwise() %>%
  mutate(
    LSTALVDT = max(c(VS_LASTDT, AE_LASTDT, DS_LASTDT, EX_LASTDT), na.rm = TRUE)
  ) %>%
  ungroup()

# Replace invalid max values
adsl <- adsl %>%
  mutate(
    LSTALVDT = if_else(is.infinite(LSTALVDT), as.Date(NA), as.Date(LSTALVDT, origin = "1970-01-01"))
  )

# Final dataset
adsl_final <- adsl %>%
  select(
    STUDYID, USUBJID, SUBJID, SITEID, AGE, AGEGR9, AGEGR9N,
    SEX, RACE, ARM, ACTARM, ITTFL, TRTSDTM, ABNSBPFL, LSTALVDT, CARPOPFL
  )

print(head(adsl_final))

write.csv(adsl_final, "adsl.csv", row.names = FALSE)