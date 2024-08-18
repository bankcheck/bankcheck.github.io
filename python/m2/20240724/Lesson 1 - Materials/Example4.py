import os
dirname = os.path.dirname(__file__)
fob = open(dirname + "/test.txt", "r")
print(fob.read(4))
fob.close()
