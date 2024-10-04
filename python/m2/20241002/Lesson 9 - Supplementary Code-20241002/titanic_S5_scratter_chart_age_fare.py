import pandas as pd
import matplotlib.pyplot as plt

titanic = pd.read_csv("titanic.csv")

plt.scatter(titanic['Age'], titanic['Fare'], alpha=0.5)
plt.xlabel('Age')
plt.ylabel('Fare')
plt.title('Age vs. Fare')
plt.show()
