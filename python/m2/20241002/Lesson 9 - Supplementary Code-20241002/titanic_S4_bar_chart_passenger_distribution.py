import pandas as pd
import matplotlib.pyplot as plt

titanic = pd.read_csv("titanic.csv")

plt.bar(titanic['Pclass'].unique(), titanic['Pclass'].value_counts())
plt.xlabel('Passenger Class')
plt.ylabel('Count')
plt.title('Passenger Class Distribution')
plt.show()
