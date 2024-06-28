#for loop

#sequence data type
#string - character
words = "Python" #scope

#1. start point: string[0]
#2. end point: string[n-1], where n = len(string)
#3. operation: unit based
#4. stepwise: default = 1

#letter -> iterating variable
for letter in words:
    #operations
    print(letter)

#list / tuple - item
drinkList = ['water', 'coke', 'tea', 'soda'] #scope

#1. start point: list/tuple[0]
#2. end point: list/tuple[n-1], where n = len(list/tuple)
#3. operation: unit-based
#4. stepwise: default = 1

#drink -. iterating variable
for drink in drinkList:
    #operation
    print(drink, end = " ")

print()

#len() - length of data type (?)
sent = "hello world"
print(len(sent))

print(len(drinkList))



    

#numeric - range()

#range(num): from 0 to num-1 (exclusive)
for i in range(5):
    print(i)

#range(a, b): from a to b-1
for k in range(10, 20):
    print(k)

#range(a, b, c): fram a to b-1 with stepwise of c
for m in range(1, 11, 3):
    print(m)





#sequence index
for w in range(0, 4, 2): #scope -> index scope
    #index
    print(drinkList[w])
else:
    print("looping completed")

#CA
for p in range(10, 15):
    print("Number of Inventory:", p)


#nested loop
course = ['Arts', 'PE', 'IT']

#outer loop
for subject in course:
    hour = 1
    #inner loop
    while (hour <= 3):
        if (hour >= 2):
            print("Attending", subject, ":", hour, "hours")
        else:
            print("Attending", subject, ":", hour, "hour")
        hour = hour + 1

#CA
for a in range(10, 14):
    for b in range(1, 5):
        print(a, "x", b, "=", (a*b))




























    
