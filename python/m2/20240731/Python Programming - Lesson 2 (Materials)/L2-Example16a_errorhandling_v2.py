try:
    b = 1 + 1
    a = 10 / 0
    print(a)

#except ZeroDivisionError:
#    print ("Divided by Zero!!!")

#except (IndexError, NameError):
#    print ("Error!!!")
    
except Exception as e:
    print(type(e).__name__)
    print(str(e))
    print(e.__traceback__.tb_lineno)
