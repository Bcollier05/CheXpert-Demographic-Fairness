"""Binarize the six CheXpert disease labels and attach the patient-level split.

Label policy (documented in the README):
  - blank (not mentioned in the report) -> 0
  - uncertain (-1)                      -> 0   (U-Zeros)

Inputs  (in DATA_DIR): train_rcl.csv (one row per image), splits.csv (one row per patient)
Output  (in DATA_DIR): labels_final.csv (one row per image: path, race, split, six 0/1 labels)

Usage: set DATA_DIR to the folder holding the CSVs, then run this script.
"""
import os

import pandas as pd

# Fixed disease order, shared by training, validation, test and evaluation.
DISEASES = [
    "Lung Opacity",
    "Pneumonia",
    "Edema",
    "Atelectasis",
    "Cardiomegaly",
    "Pleural Effusion",
]
VALID_SPLITS = {"train", "valid", "test"}  # must match the labels written by the split script

DATA_DIR = os.environ["DATA_DIR"]

df = pd.read_csv(os.path.join(DATA_DIR, "train_rcl.csv"))
splits = pd.read_csv(os.path.join(DATA_DIR, "splits.csv"), usecols=["patient_id", "split"])

# Binarize: blank -> 0, uncertain (-1) -> 0.
df[DISEASES] = df[DISEASES].fillna(0).replace(-1, 0).astype(int)
assert df[DISEASES].isin([0, 1]).all().all(), "labels are not all 0/1 after binarizing"

# Attach the patient-level split. Only patient_id and split come from splits.csv,
# so analysis_race is not duplicated. validate="m:1" errors if a patient has two splits.
n_before = len(df)
df = df.merge(splits, on="patient_id", how="left", validate="m:1")
assert len(df) == n_before, "merge changed the number of rows"
assert df["split"].notna().all(), "some images have no split (patient missing from splits.csv)"
assert set(df["split"].unique()) <= VALID_SPLITS, "unexpected split value"

# One patient must belong to exactly one split.
assert (df.groupby("patient_id")["split"].nunique() == 1).all(), "patient in more than one split"

# Keep only what training and evaluation need.
keep = ["Path", "patient_id", "analysis_race", "split", "Sex", "Age", "Frontal/Lateral"] + DISEASES
df = df[keep]
df.to_csv(os.path.join(DATA_DIR, "labels_final.csv"), index=False)

# Report.
print(f"Saved {len(df)} images / {df['patient_id'].nunique()} patients")
print("\nImages per split:")
print(df["split"].value_counts())
print("\nPositive rate per disease (all images):")
print(df[DISEASES].mean().round(3))
print("\nTest set positives per disease (images):")
print(df[df["split"] == "test"][DISEASES].sum())