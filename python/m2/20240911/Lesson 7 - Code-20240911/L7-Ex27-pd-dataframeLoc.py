import pandas as pd

data = {
  "Name": ['Peter', 'Paul', 'Mary'],
  "Marks": [80, 85, 90]
}

df = pd.DataFrame(data)

print(df.loc[0])
<<<<<<< HEAD
#print(df.loc[[0,2]])
=======
print(df.loc[[0,1,2]])
>>>>>>> 9ed9ec85ef2d9633be713f86cf6fb59a1ed40854
