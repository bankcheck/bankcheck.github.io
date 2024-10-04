import pandas as pd

titanic = pd.read_csv("titanic.csv")

pc_sur_cnt = titanic.groupby("Pclass")['Survived'].value_counts().unstack()

print(pc_sur_cnt)




