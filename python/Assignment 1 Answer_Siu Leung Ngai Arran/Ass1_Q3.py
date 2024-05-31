#user input startPoint
startPoint = int(input("Starting point: "))
#user input endPoint
endPoint = int(input("Ending point: "))

#string variable result to store the result
result = ""

#loop from start to end
for index in range(startPoint, endPoint + 1):
#if index can be divided by 7, append a space and the number to the end of the result
    if (index % 7 == 0):
        result = result + " " + str(index)

if (result == ""):
#print the line if result string is empty
    print("No integers within the range can be divided by 7.")
else:
#otherwise, print the result from the second character to omit the leading space
    print("Numbers that can be divided by 7 between", startPoint, "and", endPoint)
    print(result[1:])
