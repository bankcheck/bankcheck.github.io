#break statement
"""
for i in range(18, 66):
    #if (i == 25):
    #    print("Money")
    #    break
    print("Age", i, ": working")
    if (i == 25):
        print("Money")
        break
else:
    print("completed")
"""

#CA

data = int(input("Enter a positive integer: "))

for i in range(data, 101):
    print(i)
    if (i % 4 == 0):
        print("The first integer meet that can be divided by 4:", i)
        break


























