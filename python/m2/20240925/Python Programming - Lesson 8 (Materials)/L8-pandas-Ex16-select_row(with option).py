import pandas as pd

pd.set_option('display.max_columns', None)
titanic = pd.read_csv("titanic.csv")

above_35 = titanic[titanic["Age"] > 35]

print(above_35.head(10))



