fob = open("C:/Python/test.txt", 'r')
for line in fob:
    if(len(line) < 5):
        print(line)
fob.close()
