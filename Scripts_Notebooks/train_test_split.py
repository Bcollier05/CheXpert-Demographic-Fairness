import os
import pandas as pd
from sklearn.model_selection import train_test_split

SEED = 42  # one constant, reused for both calls

DATA_DIR = os.environ["DATA_DIR"]
df = pd.read_csv(os.path.join(DATA_DIR, "train_rcl.csv"))

# 1. One row per patient
patients = df[["patient_id", "analysis_race"]].drop_duplicates()  # patient_id + analysis_race
assert patients["patient_id"].is_unique

# 2. 85% train, 15% test
train_p, test_p = train_test_split(
    patients, test_size=.15, stratify=patients["analysis_race"], random_state=SEED
)


# 3. Label each patient with its split, stack them, save to DATA_DIR/splits.csv
assert not set(train_p["patient_id"]) & set(test_p["patient_id"]), "patient in both splits"
assert len(train_p) + len(test_p) == len(patients)

print(train_p["analysis_race"].value_counts(normalize=True).round(3))
print(test_p["analysis_race"].value_counts(normalize=True).round(3))
print("Black patients in test:", (test_p["analysis_race"] == "Black").sum())

splits = pd.concat([train_p.assign(split="train"), test_p.assign(split="test")])
splits.to_csv(os.path.join(DATA_DIR, "splits.csv"), index=False)