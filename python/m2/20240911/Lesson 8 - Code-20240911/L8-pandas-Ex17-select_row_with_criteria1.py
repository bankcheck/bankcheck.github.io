import pandas as pd

titanic = pd.read_csv("titanic.csv")

class_23 = titanic[titanic["Pclass"].isin([2, 3])]

print(class_23.head(10))



