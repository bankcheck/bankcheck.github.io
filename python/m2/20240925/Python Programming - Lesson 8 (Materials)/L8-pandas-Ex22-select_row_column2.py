import pandas as pd

titanic = pd.read_csv("titanic.csv")

sample = titanic.iloc[9:25, 2:5]

print(sample)




