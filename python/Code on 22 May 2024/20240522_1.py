#while loop

#1. current status / start point
a = 20

while (a <= 30): #2. condition / end point / expected status
    #3. operations
    print(a)
    #4. stepwise / change of status
    a = a + 2
else: #operations after completed looping
   print("looping completed")

#print("looping completed")
    
"""
#200 100 50 25
b = 200
words = ""

while (b >= 25):
    if (words == ""):
        words = words + str(b)
    else:
        words = words + ", " + str(b)
    #print(b, end = " ")
    b = int(b / 2)

print(words)
"""

#CA
lecture = 1

while (lecture <= 4):
    print("You are having", lecture, "lesson")
    lecture = lecture + 1
else:
    print("All lessons are completed")

























