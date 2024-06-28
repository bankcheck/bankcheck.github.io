print("############ string method ############")

word = "hello World"
print(word.upper())
print(word.lower())
print(word.capitalize())
print(len(word))

#apply for unicode only. cannot use for ASCII
#isalpha only for a-z and A-Z
print(word.isalpha())
print(word.isnumeric())

print("############ list ############")
l = ["x", "y", "z"]
l.append("a")
print(l)
l[0:2] = "juice", "tea"
print(l)
l[0:2] = ["coke", "oj"]
print(l)
del l[0]
print(l)
l.append("z")
print(l)
l.remove("z")
print(l)

listA = ["zzz", "aaa", "AAA", "ZZZ"]
print(len(listA))
listA.sort()
print(listA)
print(listA.count("aaa"))

print("############ tuple ############")
numList = [10, 5, 4, 12]
t = tuple(numList)
print(t)
print(len(t))
print(max(t))
print(min(t))

sTuple = ("Bread", "apple", "milk")
print(max(sTuple))
print(min(sTuple))

print("############ dictionary ############")
d = {"a":1, "b":2}
print (d)
print(d["a"])
d["c"]=3
d["a"]=4
print (d)
del d["b"]
print (d)
