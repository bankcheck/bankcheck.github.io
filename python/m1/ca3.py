nDict = {}
length = 0
s = input("Enter the student's name (Type 'End' to quit): ")

while (s.lower() != "end"):
    length += 1
    nDict[length] = s
    s = input("Enter the student's name (Type 'End' to quit): ")

print("There are", length, "students.")
print("Current Student List (with Class Number):", nDict)
    
