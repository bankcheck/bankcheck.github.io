import pandas as pd

titanic = pd.read_csv("titanic.csv")

titanic['Testing'] = "new_column"

print(titanic.head(10))



