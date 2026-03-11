\# Question 3 - ADaM ADSL Dataset Creation



This folder contains the script used to create an ADSL dataset from SDTM input data using Pharmaverse-style tools and tidyverse logic.



\## Files



\- `create\_adsl.R` - Main ADSL creation script

\- `adsl.csv` - Output ADSL dataset



\## Input datasets



\- `pharmaversesdtm::dm`

\- `pharmaversesdtm::vs`

\- `pharmaversesdtm::ex`

\- `pharmaversesdtm::ds`

\- `pharmaversesdtm::ae`



\## Derived variables



\- `AGEGR9`

\- `AGEGR9N`

\- `TRTSDTM`

\- `ITTFL`

\- `ABNSBPFL`

\- `LSTALVDT`

\- `CARPOPFL`



\## Notes



The script starts from DM as the subject-level base dataset and derives additional analysis variables using exposure, vital signs, adverse events, and disposition data.

