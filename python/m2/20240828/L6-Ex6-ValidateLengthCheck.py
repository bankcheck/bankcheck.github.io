while True:
    try:
        phone = int(input("Please enter your phone number: "))
    except ValueError:
        print("Invalid input, enter a valid value")
        continue
    if len(str(phone)) != 8:
        print("Your phone number must be 8-digit.")
        continue
    else:
        break
		
print("Your Phone Number is " + str(phone))

	