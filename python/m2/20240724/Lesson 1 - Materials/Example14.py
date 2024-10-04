districts = ["Kwun Tong\n", "Sha Tin\n", "Wong Tai Sin"]
fob = open("test_write.txt", "w")
fob.writelines(districts)
fob.close()
