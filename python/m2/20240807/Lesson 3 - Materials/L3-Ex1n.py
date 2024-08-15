class Dog:

    def __init__(self, name, age):  
        self.name = name
        self.age = age

    def bark(self):
        print("bark bark!")

    def doginfo(self):
        print(self.name + " is " + str(self.age) + " year(s) old.")

golden = Dog("Golden", 4)
silver = Dog("Silver", 6)
smallq = Dog("Small Q", 8)

golden.doginfo()
silver.doginfo()
smallq.doginfo()

golden.age = 5
print(golden.age)
