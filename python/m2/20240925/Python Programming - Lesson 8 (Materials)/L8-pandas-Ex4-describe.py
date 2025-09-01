import pandas as pd

df = pd.DataFrame(
    {
        "Name": [
            "Braund, Mr. Owen Harris",
            "Allen, Mr. William Henry",
            "Bonnell, Miss. Elizabeth"
        ],
        "Age": [22, 35, 58],
        "Sex": ["male", "male", "female"]
    }
)

#Only non-textual data will be taken account by default
print(df.describe())
#Specify a column to be described
print(df[["Name", "Sex"]].describe())
