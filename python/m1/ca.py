s = input("Enter a sentence: ")
f = input("Enter a word to be found: ")
if f.upper() in s.upper():
    print("Found: " + f)
else:
    print(f + " cannot be found")        
