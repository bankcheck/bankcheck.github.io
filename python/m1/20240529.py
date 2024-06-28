print("############ pass ############")
a = 1

if (a != 1):
    pass
else:
    print("pass")

print("############ math lib ############")
import math

print(math.pi)
print(math.e)


print("############ random lib ############")
import random
l = [1, 2,3]
print(random.choice(l))

# pick from 0 to 10
print(random.randrange(11))

# 1 to 10
print(random.randrange(1, 11))

# 1 to 10 step 3: 1,4,7,10
print(random.randrange(1, 11, 3))

#shuffle (no return value)
random.shuffle(l)
print(l)

print("############ string operation ############")
#in / not in
if 1 in l:
    print("\tin")
    print(r"\tin")
if 4 not in l:
    print("\tnot in")
    print(R"\tnot in")

name = "Lee"
age = 18

print("Hello, my name is %s. I am %d year old" %(name, age))

ch = "A"
#print ("character=%c. ASCII=%d" %(ch,ch))
print ("character=%c" %(ch))

