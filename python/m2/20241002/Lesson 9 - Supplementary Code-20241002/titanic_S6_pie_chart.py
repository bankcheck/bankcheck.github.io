import pandas as pd
import matplotlib.pyplot as plt

titanic = pd.read_csv("titanic.csv")

gender_counts = titanic['Sex'].value_counts()
plt.pie(gender_counts, labels=gender_counts.index, autopct='%1.1f%%', startangle=90)
plt.title('Survival Rate by Gender')
plt.axis('equal')
plt.show()
