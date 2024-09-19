import pandas as pd

list = [7, 8, 9]

pdseries = pd.Series(list, index = ["a", "b", "c"])

print(pdseries["a"])     

