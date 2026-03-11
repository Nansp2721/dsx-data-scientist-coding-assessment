from agent import ClinicalTrialDataAgent

agent = ClinicalTrialDataAgent()

example_questions = [
    "Give me the subjects who had adverse events of Moderate severity",
    "Show me subjects with Cardiac adverse events",
    "Which subjects had Headache?"
]

for question in example_questions:
    print("\n" + "=" * 80)
    result = agent.run_query(question)
    print("Question:", result["question"])
    print("Parsed Output:", result["parsed_output"])
    print("Unique Subject Count:", result["unique_subject_count"])
    print("Matching USUBJID:", result["matching_usubjid"])