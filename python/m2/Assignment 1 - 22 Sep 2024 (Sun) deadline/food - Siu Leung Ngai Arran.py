#Function to validate user input: return ture if valid, return false if invalid
def validate(inputStr):
    #Remove space and test the input string with isalpha method
    testStr = inputStr.replace(' ','')
    if testStr.isalpha():
        return True
    else:
        #Print case 4 invalid input message
        print("Invalid input. Please enter English letters only.")
        return False
try:
    #Open menu file
    with open("C:/food/menu.csv", "r") as fob:

        #Empty dictionary foodDict to store food and price
        foodDict = {}

        #Read and discard the first header line
        fob.readline()

        #Read the rest of the centent of the file
        for line in fob:

            #On each line, store the name and the price to the dictionary.
            #Remove the ending new line character on the price. 
            item = line.split(',')
            foodDict[item[0]] = item[2].removesuffix('\n')

        #Get user input and convert to upper case for case insensitive comparison
        userInput = input("Enter a character or characters: ").upper()

        #Test user input against the validate function and ask user to re-enter if input is invalid 
        while not validate(userInput):
            userInput = input("Enter a character or characters: ").upper()

        #Boolean variable found to store rather input is found.
        #Default is not found.
        found = False

        #Check every keys in foodDict
        for key in foodDict.keys():

            #If matching item is found
            if key.upper().startswith(userInput):
                
                #Print the heading line if this is the first matching item:
                if not found:
                    print("Matching items:")
                    found = True

                #Normal case, print the matching item:    
                print("- " + key + ": $" + foodDict[key])

        #Print case 5 when no match items found
        if not found:
            print("No matching items found.")

#Handle case 6 when menu.csv does not exist 
except (FileNotFoundError):
    print ("The Menu cannot be found!")

#Handle other exceptions for debug    
except Exception as e:
    print("Error: " + type(e).__name__ + " at line " + str(e.__traceback__.tb_lineno))