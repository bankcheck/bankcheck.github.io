def sq(n):
    return n**2

def perimeter(n):
    return n*4

l = float(input("Enter the length: "))
print("----------------------")
print("Menu")
print("1. Calculate the Area")
print("2. Calculate the Area and Perimeter")
print("----------------------")
o = input("Options: ")

if (o == "1"):
    print("Area:", sq(l))
elif (o == "2"):
    print("Area:", sq(l))
    print("Perimeter:", perimeter(l))
else:
    print("Invalid Input")
