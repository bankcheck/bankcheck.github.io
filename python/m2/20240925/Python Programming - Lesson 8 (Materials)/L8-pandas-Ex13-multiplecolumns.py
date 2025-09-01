import pandas as pd

titanic = pd.read_csv("titanic.csv")

age_sex = titanic[["Age", "Sex"]]
print(age_sex.head(10))



