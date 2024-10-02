#Import pandas
import pandas

#Read source file
result = pandas.read_csv("result.csv")

#Print the highest exam mark
print("Highest Exam Marks:")
print(result["Exam"].max())

#Print average assignment 1 mark
print("Average Assignment1 Marks:")
print(result["Assignment1"].mean())

#Locate student with empty assignment 2 marks and print their studint id and names
print("Without Submitting Assignment2:")
print(result.loc[result["Assignment2"].isnull(), ["Stud_ID", "Name"]])

#Calculate final mark and assign to new series Final_Marks
result["Final_Marks"] = result["Assignment1"] + result["Assignment2"] + result["Class_Participation"] + result["Exam"]

#Add Final Grade series
result["Final_Grade"] = ""

#For each row
for i in range(len(result)):

    #Get Final_Marks from the second last series and convert to float for comparison
    mark = float(result.iloc[i,-2])

    #Grade E if less than 50
    if mark < 50:
        grade = "E"
    #Grade D if between 50 and less than 65
    elif mark < 65:
        grade = "D"
    #Grade C if between 65 and less than 80      
    elif mark < 80:
        grade = "C"
    #Grade B if between 80 and less than 90              
    elif mark < 90:
        grade = "B"
    #Grade A if more than or equal to 90
    elif mark >= 90:
        grade = "A"
    #Otherwise, final grade is not a number
    else:
        grade = ""

    #Assign grade to the last series Final Grade
    result.iloc[i,-1] = grade

#Print the whole dataframe
print(result)

#Save to result.xlsx excel file 
with pandas.ExcelWriter("result.xlsx", engine="openpyxl", mode="w") as writer:
    result.to_excel(writer, sheet_name="Assessment", index=False)