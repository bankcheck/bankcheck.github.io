line_number = 2
fob = open("C:/Python/test.txt", 'r')
currentline = 1
for line in fob:
    if(currentline == line_number):
        print(line)
        break
    currentline = currentline + 1
fob.close()
