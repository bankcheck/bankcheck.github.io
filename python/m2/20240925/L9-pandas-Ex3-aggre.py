import pandas as pd

titanic = pd.read_csv("titanic.csv")

class_count = titanic["Pclass"].value_counts()

print(class_count)





