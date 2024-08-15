class Dog:

    def __init__(self, name, age):  
        self.name = name
        self.age = age

golden = Dog("Golden", 4)
print(golden.name + " is " + str(golden.age) + " year(s) old.")

