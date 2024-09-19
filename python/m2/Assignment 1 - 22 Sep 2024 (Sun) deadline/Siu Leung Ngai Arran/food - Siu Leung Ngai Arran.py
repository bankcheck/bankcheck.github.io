#Re-submit using re
import re

#Function to validate user input: return True if valid, return False if invalid
def validate(inputStr):

    #any string contains alphabets or spaces
    regex = r'[A-Za-z ]*'

    #The requirement does not indicate how to handle empty string input. Assume invalid
    if len(inputStr) > 0 and re.fullmatch(regex, inputStr):
        #return True if valid
        return True        
    else:
        #Print case 4 invalid input message and return false
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

            #Remove the ending new line character if any
            if line[-1] == '\n':
                line = line[:-1]

            #Store the name and the price to the dictionary.
            item = line.split(',')
            foodDict[item[0]] = item[2]

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