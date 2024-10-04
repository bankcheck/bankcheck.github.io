import pandas as pd

titanic = pd.read_csv("titanic.csv")

oldest_5_passengers = titanic.sort_values(by="Age", ascending=False).head(5)

print("The oldest 5 passengers in the Titanic dataset are:")
for index, row in oldest_5_passengers.iterrows():
    print(f"{index}: {row['Name']} with age {row['Age']}")
