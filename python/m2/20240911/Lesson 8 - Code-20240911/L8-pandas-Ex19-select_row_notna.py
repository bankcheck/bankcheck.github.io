import pandas as pd

titanic = pd.read_csv("titanic.csv")

age_no_na = titanic[titanic["Age"].notna()]

print(age_no_na.head(10))




