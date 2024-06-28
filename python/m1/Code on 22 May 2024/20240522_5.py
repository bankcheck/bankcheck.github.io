#CA

ticket = int(input("How many ticjets you want to buy: "))
mem = input("Are you the member (Y/N) ")
stu = input("Are you a student (Y/N) ")

print("Original price:", float(ticket * 50))

if (mem == "Y"):
    if (stu == "Y"):
        print("Total price:", (ticket * 50 * 0.8))
    else:
        print("Total price:", (ticket * 50 * 0.9))
else:
    if (stu == "Y"):
        print("Total price:", (ticket * 50 * 0.95))
        print("You can get a $10 coupon")
    else:
        print("Sorry No discount.")














