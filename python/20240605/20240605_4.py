#Dictionary

#create
#1. create with key values pair
drinkDict = {'water': 10, 'tea': 20}
print(drinkDict)

#2. empty dictionary
foodDict = {}
print(foodDict)


#access by keys
print(drinkDict['water'])


#add or update
#if key does not exist, add
drinkDict['soda'] = 5
print(drinkDict)
#if key exists, update
drinkDict['tea'] = 3
print(drinkDict)

#delete by keys
del drinkDict['soda']
print(drinkDict)
































