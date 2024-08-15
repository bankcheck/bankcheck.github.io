class Encap:
   def __init__(self):
      self.a = 123
      self.__b = 456
      

obj = Encap()
print(obj.a)
print(obj.__b)


