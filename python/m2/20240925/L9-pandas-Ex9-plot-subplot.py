import pandas as pd
import matplotlib.pyplot as plt

air_quality = pd.read_csv("air_quality_no2.csv", index_col=0, parse_dates=True)

air_quality.plot.area(figsize=(12, 4), subplots=True)

plt.show()
