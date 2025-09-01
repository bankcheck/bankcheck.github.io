import pandas as pd

titanic = pd.read_csv("titanic.csv")

age_na = titanic[titanic["Age"].isna()]
#age_is_null = titanic[titanic["Age"].isnull()]

print(age_na.head(10))




