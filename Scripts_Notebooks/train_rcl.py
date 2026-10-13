"""Join CheXpert train.csv to the SQL-derived race labels.

Inputs  (in DATA_DIR): train.csv, demographic_data_rcl.csv
Outputs (in DATA_DIR): train_rcl.csv

Usage: set DATA_DIR to the folder holding the CSVs, then run this script.
"""
import os
import pandas as pd

DATA_DIR = os.environ["DATA_DIR"]

train_df = pd.read_csv(os.path.join(DATA_DIR, "train.csv"))
race_df = pd.read_csv(os.path.join(DATA_DIR, "demographic_data_rcl.csv"),
                      usecols=["patient_id", "analysis_race"])

# Extract patientNNNNN from the image path; stop if any row fails.
train_df["patient_id"] = train_df["Path"].str.extract(r"(patient\d+)", expand=False)
assert train_df["patient_id"].notna().all(), "patient_id extraction failed for some rows"

# Left join keeps every image; validate raises if a patient has >1 label row.
merged = train_df.merge(race_df, on="patient_id", how="left", validate="m:1", indicator=True)

# Report the exclusions before dropping them.
dropped = merged[merged["_merge"] == "left_only"]
print(f"Excluded (no race label): {len(dropped)} images, {dropped['patient_id'].nunique()} patients")

# The exclusion is explicit: keep only rows that matched a label.
train_rcl = merged[merged["_merge"] == "both"].drop(columns="_merge")
assert train_rcl["analysis_race"].notna().all(), "null analysis_race after filtering"

train_rcl.to_csv(os.path.join(DATA_DIR, "train_rcl.csv"), index=False)