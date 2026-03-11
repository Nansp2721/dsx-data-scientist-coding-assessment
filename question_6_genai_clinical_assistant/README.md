\# Question 6 - GenAI Clinical Data Assistant



This folder contains a simple clinical data assistant that converts natural language questions into structured Pandas filters.



\## Files



\- `agent.py` - ClinicalTrialDataAgent class

\- `run\_examples.py` - Script that runs 3 example queries

\- `adae.csv` - Input adverse event dataset

\- `requirements.txt` - Python dependencies



\## Design



This solution demonstrates the full logic flow required by the assessment:



1\. Define dataset schema

2\. Parse natural language question

3\. Convert it to structured output:

&#x20;  - `target\_column`

&#x20;  - `filter\_value`

4\. Execute a Pandas filter

5\. Return matching subjects



A mock LLM-style parser is used instead of a live API call, which is allowed by the assessment brief.



\## Example questions



\- Give me the subjects who had adverse events of Moderate severity

\- Show me subjects with Cardiac adverse events

\- Which subjects had Headache?



\## Running locally



Install dependencies:



```bash

pip install -r requirements.txt

