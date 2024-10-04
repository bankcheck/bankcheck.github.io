import pandas as pd

titanic = pd.read_csv("titanic.csv")

titanic.loc[titanic["Age"].isna(), "Age"] = 0
print(titanic[["Name", "Age"]].head(10))




