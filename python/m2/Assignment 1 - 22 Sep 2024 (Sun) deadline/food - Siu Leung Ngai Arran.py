try:
    #Open menu file
    with open("C:/food/menu.csv", "r") as fob:
        #read and discard the first header line
        fob.readline()
         
        print(fob.readline())

#Handle case 6 when menu.csv does not exist 
except (FileNotFoundError):
    print ("The Menu cannot be found!")

#Handle other exceptions for debug    
except Exception as e:
    print("Error: " + type(e).__name__ + " at line " + str(e.__traceback__.tb_lineno))