while True:
    try:
        phone = int(input("Enter your phone number: "))
    except ValueError:
        print("Invalid input, enter a valid value without space")
        continue
    else:
        break
		
print("Your Phone Number is " + str(phone))

