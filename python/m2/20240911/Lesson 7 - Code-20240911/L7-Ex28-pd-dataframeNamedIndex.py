import pandas as pd

data = {
  "Name": ['Peter', 'Paul', 'Mary'],
  "Marks": [80, 85, 90]
}

df = pd.DataFrame(data, index = ["stud1", "stud2", "stud3"])

print(df)

