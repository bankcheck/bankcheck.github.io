import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

options = Options()
options.headless = True
options.add_argument("--window-size=1920,1200")
#options.add_argument("download.default_directory=C:\Downloads")


driver = webdriver.Chrome(options=options, executable_path=r"C:\Drivers\chromedriver")
driver.command_executor._commands["send_command"] = ("POST", '/session/$sessionId/chromium/send_command')

params = {'cmd': 'Page.setDownloadBehavior', 'params': {'behavior': 'allow', 'downloadPath': "C:\Downloads"}}
command_result = driver.execute("send_command", params)

driver.get("https://www.python.org/downloads/release/python-397/")
time.sleep(5)    #sleep for 5s
download_link = driver.find_element_by_xpath("/html/body/div/div[3]/div/section/article/table/tbody/tr[6]/td[1]/a")
download_link.click()
print(driver.title)
print(driver.current_url)
time.sleep(100)    #sleep for 100s
driver.close()



