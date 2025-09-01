import pandas as pd

titanic = pd.read_csv("titanic.csv")

adult_names = titanic.loc[titanic["Age"] > 35, "Name"]

print(adult_names.head(10))




