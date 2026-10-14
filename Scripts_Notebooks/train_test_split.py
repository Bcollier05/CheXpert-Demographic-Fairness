import os
import pandas as pd
from sklearn.model_selection import train_test_split

SEED = 42  # one constant, reused for both calls

DATA_DIR = os.environ["DATA_DIR"]
df = pd.read_csv(os.path.join(DATA_DIR, "train_rcl.csv"))

# 1. One row per patient
patients = df[["patient_id", "analysis_race"]].drop_duplicates()  # patient_id + analysis_race
assert patients["patient_id"].is_unique

# 2. 70% train, 30% hold (for test/val split)
train_p, hold_p = train_test_split(
    patients, test_size=.30, stratify=patients["analysis_race"], random_state=SEED
)

# 3. 15% test, 15% valid
test_p, valid_p = train_test_split(
    hold_p, test_size =.50, stratify=hold_p["analysis_race"], random_state=SEED
)


# 4. Label each patient with its split, stack them, save to DATA_DIR/splits.csv
splits = pd.concat([
    train_p.assign(split="train"),
    valid_p.assign(split="valid"),
    test_p.assign(split="test"),
])

assert splits["patient_id"].is_unique, "patient in more than one split"
assert len(splits) == len(patients)

for name, part in [("train", train_p), ("val", valid_p), ("test", test_p)]:
    print(name, len(part), "| Black:", (part["analysis_race"] == "Black").sum())
    print(part["analysis_race"].value_counts(normalize=True).round(3), "\n")

splits.to_csv(os.path.join(DATA_DIR, "splits.csv"), index=False)
print(splits.head())
