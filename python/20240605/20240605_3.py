#tuple

#create
drinkTuple = ('water', 'soda', 'milk')
print(drinkTuple)

#access
print(drinkTuple[0])
print(drinkTuple[1:2])

#add or update
#not allow in tuple

#delete
#by item
#del drinkTuple[0] 

#whole tuple
del drinkTuple
#print(drinkTuple)


#common methods
numList = [10, 5, 4, 12]

numTuple = tuple(numList)
print(numTuple)
print(len(numTuple))
print(max(numTuple))
print(min(numTuple))


foodTuple = ("Bread", "milk", "apple")

print(max(foodTuple))
print(min(foodTuple))


foodTuple2 = (100, "Bread", 200, "milk")
#print(max(foodTuple2)) #error - different data types
#print(min(foodTuple2))

#CA
product = []
item = ""
confirm = "N"

while (item != "NA"):
    item = input("Enter the item (NA to end the input): ")
    if (item != "NA"):
        product.append(item)

print("Existing Product List: ", product)
print("---------------------------------------")

while (confirm.upper() != "Y"):
    confirm = input("Confirm the product list? (Y/N) ")
    if (confirm.upper() == "Y"):
        productTuple = tuple(product)
        print(productTuple)
        print("Number of items in product list: ", len(productTuple))
    else:
        print("Existing Product List: ", product)
        option = int(input("Please indicate the item no. to be updated: "))
        updatedItem = input("Please input the new item: ")
        product[(option - 1)] = updatedItem
        print("Updated Product List: ", product)
    print("--------------------------------")














































