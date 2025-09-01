import pandas as pd

titanic = pd.read_csv("titanic.csv")

sex_age_mean = titanic[["Sex", "Age"]].groupby("Sex").mean()

print(sex_age_mean)




