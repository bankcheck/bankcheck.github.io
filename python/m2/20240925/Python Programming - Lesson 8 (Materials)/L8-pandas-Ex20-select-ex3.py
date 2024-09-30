import pandas as pd

titanic = pd.read_csv("titanic.csv")

index = titanic.loc[titanic["Age"].isna(), "PassengerId"]
print(titanic.loc[titanic["PassengerId"].isin(index), ["Name", "Age"]]) 

print("*****************")

titanic.loc[titanic["Age"].isna(), "Age"] = titanic["Age"].mean()
print(titanic.loc[titanic["PassengerId"].isin(index), ["Name", "Age"]]) 






