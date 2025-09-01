import pandas as pd

titanic = pd.read_csv("titanic.csv")

ages = titanic["Age"]
print(ages.head(10))


