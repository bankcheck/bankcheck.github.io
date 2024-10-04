import pandas as pd
import matplotlib.pyplot as plt

titanic = pd.read_csv("titanic.csv")

survival_counts = titanic.groupby(['Pclass', 'Sex'])['Survived'].sum().unstack()
survival_counts.plot(kind='bar', stacked=True)
plt.xlabel('Passenger Class')
plt.ylabel('Survival Count')
plt.title('Survival by Passenger Class and Gender')
plt.legend(title='Gender', loc='upper left')
plt.show()
