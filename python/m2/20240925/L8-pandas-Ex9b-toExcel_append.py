import pandas as pd

titanic = pd.read_csv("titanic.csv")

file_path = "titanic.xlsx"

with pd.ExcelWriter(file_path, engine='openpyxl', mode='a') as writer:
    titanic.to_excel(writer, sheet_name="new_passengers", index=False)
