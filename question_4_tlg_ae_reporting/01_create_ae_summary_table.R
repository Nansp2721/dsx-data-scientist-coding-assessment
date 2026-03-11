library(dplyr)
library(gtsummary)
library(gt)
library(pharmaverseadam)

adae <- pharmaverseadam::adae
adsl <- pharmaverseadam::adsl

teae <- adae %>%
  filter(TRTEMFL == "Y") %>%
  select(USUBJID, AETERM, ACTARM) %>%
  distinct()

ae_summary <- teae %>%
  tbl_summary(
    by = ACTARM,
    include = AETERM,
    statistic = all_categorical() ~ "{n} ({p}%)",
    missing = "no"
  ) %>%
  add_overall(last = TRUE) %>%
  modify_header(label ~ "**AE Term**") %>%
  bold_labels()

gt_tbl <- as_gt(ae_summary)

gtsave(gt_tbl, "ae_summary_table.html")