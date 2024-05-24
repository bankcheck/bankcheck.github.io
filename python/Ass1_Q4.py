# user input line
line = input("Input a string: ")

# initialize result to 0 
counter = 0

# for each character ch in line
for ch in line:
# if it is not a space, increment the counter
    if (ch != " "):
        counter += 1

print("Number of characters (no spaces):", counter)