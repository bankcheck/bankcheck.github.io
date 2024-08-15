class Encap:
   def __init__(self):
      self.__number = 50

   def getNumber(self):
      print(self.__number)

   def setNumber(self, number):
      self.__number = number

obj = Encap()
obj.getNumber()
obj.setNumber(51)
obj.getNumber()
print(obj.__number)

