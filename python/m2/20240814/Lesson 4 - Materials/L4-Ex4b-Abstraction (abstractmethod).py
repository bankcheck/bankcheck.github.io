#From abc module import ABC Class
from abc import ABC, abstractmethod  
  
class Polygon(ABC):   
   #Abstract Method
   @abstractmethod
   def angles(self):
      pass

   #Normal Method
   def sides(self):   
      pass  
  
class Triangle(Polygon):
   def angles(self):
      print("Triangle has 180 deg")    
   
   def sides(self):   
      print("Triangle has 3 sides")   
  
class Square(Polygon):
   def angles(self):
      print("Square has 360 deg")
   
   def sides(self):   
      print("Square has 4 sides")   
  
#Execution  
t = Triangle()   
t.sides()
t.angles()
  
s = Square()   
s.sides()
s.angles()


