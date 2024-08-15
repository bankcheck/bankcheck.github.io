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

golden = Dog("Golden", 4)

print(golden.age)   #Before Birthday – Age
golden.birthday()
print(golden.age)   #After Birthday – Age

