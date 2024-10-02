import time
from selenium import webdriver

<<<<<<< HEAD
driver = webdriver.Chrome(r'C:\Drivers\chromedriver.exe')
=======
driver = webdriver.Chrome(r'C:\Drivers\chromedriver')
>>>>>>> cab6705ad12f552b9caa563f10ac913916fd2e04
driver.get("https://www.python.org")
print(driver.title)
print(driver.current_url)
time.sleep(60)    #sleep for 60s
driver.close()


