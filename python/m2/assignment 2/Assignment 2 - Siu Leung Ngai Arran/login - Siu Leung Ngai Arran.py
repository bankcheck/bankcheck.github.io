#Import selenium webdriver
from selenium import webdriver
#Import selenium selector
from selenium.webdriver.common.by import By
#Import selenium service if chromedriver does not work
from selenium.webdriver.chrome.service import Service
#Import chrome driver
from webdriver_manager.chrome import ChromeDriverManager
#Import os to get current path name
import os

#function login takes parameters username, password, screenshot file path
def login(pUsername, pPassword, pFilename):

    #Define the chrome driver
    driver = webdriver.Chrome('C:\Drivers\chromedriver')
    #Uncommend the code below if Chromedriver does not work
    #s = Service(ChromeDriverManager().install())
    #driver = webdriver.Chrome(service=s)

    #Open the destination URL
    driver.get("https://practicetestautomation.com/practice-test-login/")
    #Identify the element username and store it in variable eUsername
    eUsername = driver.find_element(By.ID, "username")
    #Identify the element password and store it in variable ePassword
    ePassword = driver.find_element(By.ID, "password")
    #Identify the submit button element username and store it in variable eSubmit
    eSubmit = driver.find_element(By.ID, "submit")

    #Clear and enter the field username 
    eUsername.clear()
    eUsername.send_keys(pUsername) 

    #Clear and enter the field password 
    ePassword.clear()
    ePassword.send_keys(pPassword) 

    #similate the click submit button event
    eSubmit.click()

    #print current URL
    print(driver.current_url)

    #Maximize the browser for screenshot
    driver.maximize_window()

    #Take screenshot and save as the filename from the pFilename parameter 
    driver.save_screenshot(pFilename)

    #Close the browser
    driver.close()
    return

#Define correct username
correctUsername = "student"
#Define correct password
correctPassword = "Password123"
#Define incorrect username
incorrectUsername = "incorrectUser"
#Define incorrect password
incorrectPassword = "incorrectPassword"

#Get the initial input from user
choice = input("Input test case 1, 2, 3, or q for quit: ")

#Prompt until user has input a valid choice: 1, 2, 3, or q
while choice not in ['1', '2', '3', 'q']:
    choice = input("Re-enter your choice: ")

#Get current py file path
dirname = os.path.dirname(__file__)
#Construct the output screenshot filename
screenshot = dirname + "/case" + choice + ".png"

if choice == '1':
    #Test case 1, correct username and password
    login(correctUsername, correctPassword, screenshot)
elif choice == '2':
    #Test case 2, incorrect username
    login(incorrectUsername, correctPassword, screenshot)
elif choice == '3':
    #Test case 3, correct username and incorrect password
    login(correctUsername, incorrectPassword, screenshot)