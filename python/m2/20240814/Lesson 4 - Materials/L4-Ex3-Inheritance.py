class Transportation:
    def __init__(self):
        self.__speed = 0
        
    def addspeed(self, i):
        self.__speed += i

    def printSpeed(self):
        print("Current speed: " + str(self.__speed) + " m/s ")
        
#Child class Plane inherits the base class Transportation  	
class Plane(Transportation):  
    def fly(self):  
        Transportation.addspeed(self, 10)   
        
p = Plane()  
p.fly()  
p.printSpeed()  

