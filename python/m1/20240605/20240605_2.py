#list

#create
#1. list with items
drinkList = ['water', 'juice', 'soda']
print(drinkList)

#2. empty list
snackList = []
print(snackList)


#access
print(drinkList[0])
print(drinkList[1:2])

#add items - append()
#last item - maintain insertion order
drinkList.append('coffee')
print(drinkList)
#allow duplicate
drinkList.append('coffee')
print(drinkList)
#drinkList.append('coffee', 0) #error - cannot indicate index
#print(drinkList)

#update
drinkList[0] = 'coffee'
print(drinkList)
#a, b = 10, 20
drinkList[0:2] = 'juice', 'tea'
print(drinkList)
#print(drinkList[0:2])
#list = list
drinkList[0:2] = ['coke', 'lemon tea']
print(drinkList)


#delete - del
#delete by index
del drinkList[0]
print(drinkList)

#delete - remove
#remove first hit by value
drinkList.remove('coffee')
print(drinkList)


#common methods
listA = ['zzz', 'aaa', 'AAA', 'ZZZ']

print(len(listA))
listA.sort()
print(listA)

#different data types
listB = ['aaa', 'ZZZ', 100, 500]
#listB.sort() - Type Error
#print(listB)

print(listA.count('aaa'))





#CA
gradeList = []

grade = input("Enter the grade(A - E, Z to end): ")

while(grade.upper() != "Z"):
    gradeList.append(grade.upper())
    grade = input("Enter the grade(A - E, Z to end): ")

print("The grade list is: ")
print(gradeList)

check = input("Enter the grade that you want to check: ")

percentage = gradeList.count(check.upper())/len(gradeList) * 100

print("Percentage of Grade", check.upper(), "=", percentage, "%")







































