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

#Locate student with empty assignment 2 marks; print student id and names
print("Without Submitting Assignment2:")
print(result.loc[result["Assignment2"].isnull(), ["Stud_ID", "Name"]])

#Calculate final mark and assign to new series Final_Marks
result["Final_Marks"] = result["Assignment1"] + result["Assignment2"] + result["Class_Participation"] + result["Exam"]

#Add Final Grade series
result["Final_Grade"] = ""

#For each row
for index, row in result.iterrows():

    #Get Final_Marks for comparison
    mark = row["Final_Marks"]

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
    #Otherwise, final mark is not a number; keep default empty string grade

    #Assign grade to the last series Final Grade
    result.iloc[index, -1] = grade

#Print the whole dataframe
print(result)

#Save to result.xlsx excel file 
result.to_excel("result.xlsx", sheet_name="Assessment", index=False)

