print("------ function ------")

def fx(p1, p2=20):
    print(p1, p2)
    #optional return

def fx2(num, *nTuple):
    print(num)
    print(type(nTuple))
    for i in nTuple:
        print(i)
    return

def sq(num):
    return num**2

#required arguments - same order, mandate
fx("param1", 2)

#keyword arguments - diff order
fx(p2=18, p1="Peter")

#default arguments - default value (optionl)
fx("Peter")
fx(p1="a")

#variable length argument
fx2(10)
fx2(1, 2, 3)
fx2("a", "b")

#return
print(sq(10))


print("------ self learning ------")
list1 = [1, 2, 3]
list2 = list(list1)

list2[0] = "a"
print(list1)

list1 = [1, 2, 3]
list2 = list1

list2[0] = "a"
print(list1);
