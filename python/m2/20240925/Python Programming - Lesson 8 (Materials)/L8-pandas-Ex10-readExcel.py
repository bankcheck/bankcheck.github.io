import pandas as pd
import openpyxl

#titanic = pd.read_excel("titanic.xlsx", sheet_name="passengers")
titanic = pd.read_excel("titanic.xlsx", sheet_name="passengers", engine="openpyxl")

print(titanic)

