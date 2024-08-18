import os
dirname = os.path.dirname(__file__)
fob = open(dirname + "/test.txt", "r")
print(fob.readline(3))
fob.close()
