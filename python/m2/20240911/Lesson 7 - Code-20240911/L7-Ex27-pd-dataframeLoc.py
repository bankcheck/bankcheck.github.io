import pandas as pd

data = {
  "Name": ['Peter', 'Paul', 'Mary'],
  "Marks": [80, 85, 90]
}

df = pd.DataFrame(data)

print(df.loc[0])
print(df.loc[[0,1,2]])