import time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

s = Service(ChromeDriverManager().install())
driver = webdriver.Chrome(service=s)

driver.get("https://www.python.org")
print(driver.title)
#search_bar = driver.find_element_by_name("q")
#search_bar = driver.find_element(By.ID, "id-search-field")
search_bar = driver.find_element(By.XPATH, "/html/body/div/header/div/div[1]/div/form/fieldset/input")
search_bar.clear()
search_bar.send_keys("selenium")
search_bar.send_keys(Keys.RETURN)
print(driver.current_url)
time.sleep(60)    #sleep for 60s
driver.close()


