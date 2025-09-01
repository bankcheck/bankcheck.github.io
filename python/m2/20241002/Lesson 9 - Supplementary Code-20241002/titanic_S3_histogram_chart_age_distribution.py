import pandas as pd
import matplotlib.pyplot as plt

titanic = pd.read_csv("titanic.csv")

titanic["Age"].plot.hist(bins=20)
plt.xlabel("Age")
plt.ylabel("Count")
plt.title("Age Distribution")
plt.show()


