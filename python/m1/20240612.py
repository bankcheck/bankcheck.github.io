print("###### dictionary ######")

dict1 = {"a":1, "b":2}
dict2 = {"x":3, "y":4, "z":5}


dict1.update(dict2)
print(dict1)

print(type(dict1.values()))
print(type(dict1.keys()))

print("###### function ######")
#doc: string p1, int p2
def f1(p1, p2):
    print(p1, p2)
    return p2 + 1

#required arg
x = f1("a",2)
print(x)
