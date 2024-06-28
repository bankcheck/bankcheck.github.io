l = []

a = input("Enter the item (NA to end the input): ")

while (a != "NA"):
    l.append(a)
    a = input("Enter the item (NA to end the input): ")

print("Existing Product List:", end=" ")
print(l)
print("--------------------------------------")
c = input("Confirm the product list? (Y/N) ").upper()

while (c != "Y"):
    print("Existing Product List: ", end=" ")
    print(l)
    i = int(input("Please indicate the item no. to be updated: "))
    x = input("Please input the new item: ")
    l[i - 1] = x
    print("Updated Product List: ", end=" ")
    print(l)
    c = input("Confirm the product list? (Y/N) ").upper()

print("--------------------------------------")
print("Updated Product List: ", end=" ")
print(tuple(l))
print("Number of items in product list: ", len(l))
print("--------------------------------------")
              
