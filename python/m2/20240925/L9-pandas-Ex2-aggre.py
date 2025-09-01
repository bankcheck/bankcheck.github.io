import pandas as pd

titanic = pd.read_csv("titanic.csv")

sex_mean = titanic.groupby("Sex").mean()

print(sex_mean)




