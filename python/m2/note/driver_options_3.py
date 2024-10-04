import os
import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By

download_dir = os.path.join('C:\\Python', 'new_subfolder')
os.makedirs(download_dir, exist_ok=True)

options = webdriver.ChromeOptions()
options.add_argument("--headless")
options.add_experimental_option("prefs", {
  "download.default_directory": download_dir
})


driver = webdriver.Chrome(service=Service(), options=options)

driver.get("https://www.mozilla.org/en-US/firefox/new/")

time.sleep(5)
driver.save_screenshot(os.path.join(download_dir, 'download.png'))

download_button = driver.find_element(By.XPATH, "/html/body/div[3]/main/section[1]/div/div[1]/div/div[1]/a")
download_button.click()

time.sleep(60)

driver.quit()








