try:
    a = int(input("Enter an integer: "))
    b = 10 / a
    print(b)
    
except ZeroDivisionError:
    print ("Divided by Zero!!!")
    
else:
    print ("No error.")
