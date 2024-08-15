#From abc module import ABC Class
from abc import ABC  
  
class Polygon(ABC):   
   #Abstract Method(skipped)

   #Normal Method
   def sides(self):   
      pass  
  
class Triangle(Polygon):   
   def sides(self):   
      print("Triangle has 3 sides")   
  
class Square(Polygon):   
   def sides(self):   
      print("Square has 4 sides")   
  
#Execution  
t = Triangle()   
t.sides()   
  
s = Square()   
s.sides()   


