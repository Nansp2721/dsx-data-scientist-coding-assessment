library(dplyr)
library(gt)
library(pharmaverseadam)

adae <- pharmaverseadam::adae

ae_listing <- adae %>%
  filter(TRTEMFL == "Y") %>%
  select(
    USUBJID,
    ACTARM,
    AETERM,
    AESEV,
    AEREL,
    ASTDT,
    AENDT
  ) %>%
  arrange(USUBJID, ASTDT)

gt_listing <- ae_listing %>%
  gt()

gtsave(gt_listing, "ae_listing.html")