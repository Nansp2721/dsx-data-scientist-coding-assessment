\# Question 4 - Adverse Events TLG Reporting



This folder contains scripts and outputs for adverse events reporting using the Pharmaverse ADaM ADAE dataset.



\## Files



\- `01\_create\_ae\_summary\_table.R` - Creates AE summary table

\- `02\_create\_visualizations.R` - Creates AE plots

\- `03\_create\_listings.R` - Creates AE listing



\## Outputs



\- `ae\_summary\_table.html`

\- `ae\_severity\_by\_treatment.png`

\- `top10\_ae\_incidence\_ci.png`

\- `ae\_listing.html`



\## Input datasets



\- `pharmaverseadam::adae`

\- `pharmaverseadam::adsl`



\## Notes



The scripts focus on treatment-emergent adverse events (`TRTEMFL == "Y"`).

