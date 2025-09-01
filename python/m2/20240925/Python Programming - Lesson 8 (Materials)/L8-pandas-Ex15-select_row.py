import pandas as pd

titanic = pd.read_csv("titanic.csv")

above_35 = titanic[titanic["Age"] > 35]

print(above_35.head(10))



