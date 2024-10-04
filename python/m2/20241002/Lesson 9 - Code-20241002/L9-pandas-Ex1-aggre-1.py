import pandas as pd

titanic = pd.read_csv("titanic.csv")

tot = len(titanic)

sur = titanic[["Pclass", "Survived"]].groupby("Pclass").mean()

print(sur)




