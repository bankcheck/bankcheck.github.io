class Dog:

    def __init__(self, name, age):  
        self.name = name
        self.age = age

    def bark(self):
        print("bark bark!")

    def doginfo(self):
        print(self.name + " is " + str(self.age) + " year(s) old.")

    def birthday(self):
        self.age +=1

    def setBuddy(self, buddy):
        self.buddy = buddy
        buddy.buddy = self

    def doginfostr(self):
        return self.name + " is " + str(self.age) + " year(s) old."

class Cat:

    def __init__(self, name, age):  
        self.name = name
        self.age = age

    def info(self):
        print(self.name + " is " + str(self.age) + " year(s) old.")        

golden = Dog("Golden", 4)
silver = Dog("Silver", 6)
kitty = Cat("Kitty", 1)
kitty.info()

#golden.setBuddy(silver)

#print(golden.buddy.name)
#print(golden.buddy.age)

#print(silver.buddy.name)
#print(silver.buddy.age)

#print(golden.buddy.doginfo())
#print(golden.buddy.doginfostr())

golden.setBuddy(kitty)
kitty.buddy.doginfo()
golden.setBuddy(silver)
kitty.buddy.buddy.doginfo()


