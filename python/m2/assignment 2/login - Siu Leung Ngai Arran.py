import time
from selenium import webdriver

driver = webdriver.Chrome('C:\Drivers\chromedriver')
driver.get("https://www.python.org")
print(driver.title)
print(driver.current_url)
time.sleep(60)    #sleep for 60s
driver.close()