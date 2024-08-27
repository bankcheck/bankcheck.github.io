import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

s = Service(ChromeDriverManager().install())
driver = webdriver.Chrome(service=s)
driver.get("https://www.python.org")
print(driver.title)
print(driver.current_url)
time.sleep(60)    #sleep for 60s
driver.close()


