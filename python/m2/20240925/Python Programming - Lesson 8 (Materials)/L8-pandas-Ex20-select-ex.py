import pandas as pd

titanic = pd.read_csv("titanic.csv")

result = titanic[(titanic["Sex"] == "female") & (titanic["Pclass"] == 2) & (titanic["Age"] > 40)]

disp = result[["Name", "Fare"]]

print(disp)




