#print and input
print("print", "input", "comment", sep=" AND ", end = "!\n")

'''
name = input("What is your name? ")
print("Hello," + name + ". Nice to meet you.\n")
school = input("Which school are you studying? ")
print("I have not met friends from " + school + ".")
print("Nice chat with you, " + name + ". See you next time!")
'''

#indent
print("indent")
a = 1
b = 2
c = a \
    + b
print(c)

#multiple assignment
print("multiple assignment")
a=b=c=10
print(a,b,c)

d,e,f=10,2.1,"abc"
print(d,e,f)

#delete variable
del a
