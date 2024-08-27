import time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys

driver = webdriver.Chrome('C:\Drivers\chromedriver')
driver.get(r"https://elearning.scs.cuhk.edu.hk/")
print(driver.title)
print(driver.current_url)

username = driver.find_element_by_id('login_username')
username.send_keys("edward.lc.szeto")

password = driver.find_element_by_id('login_password')
password.send_keys("XXXXXXXX")

password.send_keys(Keys.RETURN)


time.sleep(60)    #sleep for 60s
driver.close()


