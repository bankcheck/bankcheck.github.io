#data type
print("data type")
a = 10
print(type(a))

b = 4 + 1j
print(type(b))

print(isinstance(a, float))
print("####################")

#string
print("string")
#  012345678901234
c = "Pytron Learning"
start = 7
#exclusive end index
end = 10
print(c[start:end])
print(c[start:])
print(c[:end])

#+ and *
d = "hello"
e = "world"
print((d + " ") * 3 + e)
print("####################")

#list
print("list")
f = ["a", 1.1, 2]
print(f)
print(type(f))
start = 0
end = 2
print(f[start:end])
g = ["b",3]
print(f + g)
print(g * 2)
#ca
a = ["coffee", "milk", "water", 35.5, 10.5, 8.0]
print(a)
print(a[1])
print(a[2:3])
print(a[4:])
print("####################")

#tuple
print("tuple")
a = ("coffee", "milk", "water", 35.5, 10.5, 8.0)
print(a)
print(a[0], a[1:3], a[:3], a[1:])
b = ("a" ,)
print(a + b)
print(b * 4)
print("####################")

#dictionary
print("dictionary")

dict = {}
dict["Peter"] = 100
dict[100] = 'A'
print(dict)

dict2 = {"Mary":98, "Ben":50}
print(dict2)
print(dict[100])
print(dict.keys())
print(type(dict.keys()))
print(dict.values())
print(type(dict.values()))

#boolean
a=True
b=False
#set: unordered data
print("####################")

#data conversion
print("data conversion")
d1 = float(input("1: "))
d2 = float(input("2: "))
print(d1 + d2)
#ca
product = {}

print("=========== Product 1===========")
name = input("Enter the name of product 1: ")
price = float(input("Enter the price of product 1: "))
product[name] = price + 5.0
print("Price of " + name + " with delivery fee: " + str(product[name]))
print("=========== Product 2===========")
name = input("Enter the name of product 2: ")
price = float(input("Enter the price of product 2: "))
product[name] = price + 10.5
print("Price of " + name + " with delivery fee: " + str(product[name]))
print("=========== Product List===========")
print(product)

