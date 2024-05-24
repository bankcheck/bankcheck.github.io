drink = int(input("How many you want to buy? "))

if drink <= 0:
    print ("Invalid value")
elif (drink > 0 and drink < 10):
    print ("Delivery fee: $50")
else:
    print ("Free delivery")
