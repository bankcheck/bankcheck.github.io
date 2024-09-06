# Input
while True:
    try:
        age = float(input("Enter age: "))

    except:
        continue    

    else:
        if age <= 0:
            continue
        else:
            break

if age >= 18:
    print("Here is your beer!")
else:
    print("Beer is not for you!")
