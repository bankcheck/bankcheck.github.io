import pandas as pd

titanic = pd.read_csv("titanic.csv")

result = titanic.loc[titanic["Sex"]=="male", ["Name", "Fare"]]

print(result)




