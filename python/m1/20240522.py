#loop
#while loop
print ("############ while loop ############")
a = 200
list = []

while (a >= 25):
    newlist = [a]
    list = list + newlist
    a = int(a / 2)

print (list)

#for loop
print ("############ for loop ############")
word = "abc"

for letter in word:
    print (letter)

print ("############ for loop list ############")
mylist = ["a", 1, "bb", 2.1]
for item in mylist:
    #print (type(item))
    if (type(item) == str):
        for subitem in item:
            print (subitem, end="-")
        print()
    else:
        print (item)                       
    
print ("############ for loop 1 ############")

for i in range(5):
    print(i)
    
print ("############ for loop 2 ############")

for i in range(5, 10):
    print(i)

print ("############ for loop range 3 ############")    
for i in range(1, 13, 4):
    print(i)


print ("############ for loop mix ############")    
for i in range(0, 4, 2):
    print(mylist[i])
else:
    print("end")

print ("############ break ############")
a = int(input("Enter a positive integer: "))

for i in range(a, 101):
    print(i)
    if (i % 4 == 0): 
        print("The first integer meet that can divided by 4: " + str(i))
        break
    
print ("############ continue ############")
a = input("Enter a sentence: ")

for c in a:
    if (c == " "): continue          
    print(c, end="")


