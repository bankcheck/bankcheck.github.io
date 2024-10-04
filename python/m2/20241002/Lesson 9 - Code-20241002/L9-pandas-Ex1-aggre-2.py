import pandas as pd

titanic = pd.read_csv("titanic.csv")

result = titanic["Sex"].value_counts()

print(result)

result = titanic["Pclass"].value_counts().sort_index()

print(result)




