# user input last
last = int(input("Input an integer: "))

# result
result = 1

#print the first part of the output
print("Sum from 1 to", last, " = 1", end="")

#calculate the result and print the middle part of the output
for i in range(2, last + 1):
    result += i
    print(" +", i, end="")

#print the last past of the output
print(" =", result)