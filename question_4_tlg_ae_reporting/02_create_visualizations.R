library(dplyr)
library(ggplot2)
library(pharmaverseadam)

adae <- pharmaverseadam::adae
adsl <- pharmaverseadam::adsl

teae <- adae %>%
  filter(TRTEMFL == "Y")

# Plot 1: AE severity distribution by treatment
plot1_data <- teae %>%
  count(ACTARM, AESEV)

p1 <- ggplot(plot1_data, aes(x = ACTARM, y = n, fill = AESEV)) +
  geom_col() +
  labs(
    title = "AE Severity Distribution by Treatment",
    x = "Treatment Arm",
    y = "Count"
  ) +
  theme_minimal()

ggsave("ae_severity_by_treatment.png", plot = p1, width = 10, height = 6, dpi = 300)

# Plot 2: Top 10 most frequent AEs with approximate 95% CI
denom <- adsl %>%
  distinct(USUBJID, ACTARM) %>%
  count(ACTARM, name = "N")

top10_data <- teae %>%
  distinct(USUBJID, ACTARM, AETERM) %>%
  count(ACTARM, AETERM, name = "n") %>%
  left_join(denom, by = "ACTARM") %>%
  mutate(
    prop = n / N,
    se = sqrt((prop * (1 - prop)) / N),
    lcl = pmax(prop - 1.96 * se, 0),
    ucl = pmin(prop + 1.96 * se, 1)
  )

top_terms <- top10_data %>%
  group_by(AETERM) %>%
  summarise(total_n = sum(n), .groups = "drop") %>%
  arrange(desc(total_n)) %>%
  slice_head(n = 10)

plot2_data <- top10_data %>%
  inner_join(top_terms, by = "AETERM")

p2 <- ggplot(plot2_data, aes(x = reorder(AETERM, prop), y = prop)) +
  geom_point() +
  geom_errorbar(aes(ymin = lcl, ymax = ucl), width = 0.2) +
  coord_flip() +
  facet_wrap(~ ACTARM) +
  labs(
    title = "Top 10 Most Frequent AEs with 95% CI",
    x = "AE Term",
    y = "Incidence Proportion"
  ) +
  theme_minimal()

ggsave("top10_ae_incidence_ci.png", plot = p2, width = 12, height = 8, dpi = 300)