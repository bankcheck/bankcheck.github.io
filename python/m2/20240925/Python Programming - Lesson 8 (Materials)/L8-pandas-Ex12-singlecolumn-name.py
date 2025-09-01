import pandas as pd

titanic = pd.read_csv("titanic.csv")

name = titanic["Name"]
print(name.head(10))


