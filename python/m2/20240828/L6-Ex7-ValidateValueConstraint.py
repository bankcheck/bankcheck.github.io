while True:
    gender = input("Please enter your gender (M or F): ")
    if gender != 'M' and gender != 'F':
        print("Invalid input")
        continue
    else:
        break
		
print("Your Gender is " + gender)

