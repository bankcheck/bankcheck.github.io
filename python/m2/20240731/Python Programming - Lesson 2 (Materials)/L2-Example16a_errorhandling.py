try:
    a = 10 / 1
    print(b)

except ZeroDivisionError:
    print ("Divided by Zero!!!")

except (IndexError, NameError):
    print ("Error!!!")
    
except Exception as e:
    print(type(e).__name__)
    print(str(e))
