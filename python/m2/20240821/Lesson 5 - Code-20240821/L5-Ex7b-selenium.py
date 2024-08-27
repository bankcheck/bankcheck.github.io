import time
from selenium import webdriver

driver = webdriver.Chrome('C:\Drivers\chromedriver')
driver.get(r"C:\Users\EdwardSzeto\OneDrive\Desktop\CUSCS\Python Module 2\Python Programming - Lesson 5 (Materials)\L5-Ex8-selenium_selector.html")
print(driver.title)
print(driver.current_url)

h1 = driver.find_element_by_tag_name('h1')
h2 = driver.find_element_by_class_name('h2')
h3 = driver.find_element_by_id('test')
p = driver.find_element_by_xpath('/html/body/p')

print(h1.text)
print(h2.text)
print(h3.text)
print(p.text)


time.sleep(60)    #sleep for 60s
driver.close()


