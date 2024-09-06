# Input
while True:
    try:
        num = float(input("Enter number: "))

    except:
        continue    

    else:
        if num < 0:
            continue
        else:
            break
