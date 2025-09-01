import pandas as pd

titanic = pd.read_csv("titanic.csv")
<<<<<<< HEAD

ages = titanic["Age"]
=======
ages = titanic[["Age","Sex","Pclass"]]
>>>>>>> 9ed9ec85ef2d9633be713f86cf6fb59a1ed40854
print(ages.shape)
age_sex = titanic[["Age", "Sex"]]
print(age_sex.shape)



