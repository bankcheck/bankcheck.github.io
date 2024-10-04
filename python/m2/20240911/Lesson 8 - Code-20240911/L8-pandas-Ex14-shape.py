import pandas as pd

titanic = pd.read_csv("titanic.csv")
ages = titanic[["Age","Sex","Pclass"]]
print(ages.shape)
age_sex = titanic[["Age", "Sex"]]
print(age_sex.shape)



