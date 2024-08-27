import time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By

driver = webdriver.Chrome('C:\Drivers\chromedriver')
driver.get("https://www.python.org")
print(driver.title)
#search_bar = driver.find_element_by_name("q")
search_bar = driver.find_element(By.NAME, "q")
search_bar.clear()
search_bar.send_keys("getting started with python")
#search_button = driver.find_element_by_id("submit")
search_button = driver.find_element(By.ID, "submit")
search_button.click()
print(driver.current_url)
time.sleep(60)    #sleep for 60s


