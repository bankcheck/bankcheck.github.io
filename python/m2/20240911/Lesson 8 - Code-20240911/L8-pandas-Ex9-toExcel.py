import pandas as pd

titanic = pd.read_csv("titanic.csv")

titanic.to_excel("titanic.xlsx", sheet_name="passengers", index=False)


