#Try to fix all the exceptions!
#Sample answer

import math

x = int(input("Give a number: "))

# Part 1: Calculate the area of circle with the given number as radius
area = math.pi * x * x
print(area)

# Part 2: Use the while loop to add from 1 to n (the given number)
i = 0
mysum = 0
while i <= x:
    mysum = mysum + i
    i+=1
print(mysum)
