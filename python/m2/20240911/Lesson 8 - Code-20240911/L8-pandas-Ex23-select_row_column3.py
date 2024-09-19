import pandas as pd

titanic = pd.read_csv("titanic.csv")

titanic.iloc[0:5, 3] = "anonymous"

id_names = titanic[["PassengerId","Name"]]

print(id_names.head(10))




