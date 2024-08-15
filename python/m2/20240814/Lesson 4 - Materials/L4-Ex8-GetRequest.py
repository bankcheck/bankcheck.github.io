import requests

x = requests.get("https://www.apple.com/hk")

print(x.text)

