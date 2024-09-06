while True:
    try:
        age = int(input("Please enter your age: "))
    except ValueError:
        print("Invalid input, enter a valid value")
        continue

    if age < 0:
        print("Your age must not be negative.")
        continue
    else:
        break

print("Your Age is " + str(age))

