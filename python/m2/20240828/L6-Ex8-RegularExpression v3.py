# Import module for regular expressions
import re
 
regex = r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'

email = input("Please enter your email: ")

if(re.fullmatch(regex, email)):
    print("Valid Email Format")
else:
    print("Invalid Email Format")
	
