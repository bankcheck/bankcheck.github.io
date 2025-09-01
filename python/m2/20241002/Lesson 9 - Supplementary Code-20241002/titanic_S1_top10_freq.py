import pandas as pd

titanic = pd.read_csv("titanic.csv")

top_10_ages = titanic['Age'].value_counts().head(10)

print("The top 10 ages in the Titanic dataset are:")
print(top_10_ages)
