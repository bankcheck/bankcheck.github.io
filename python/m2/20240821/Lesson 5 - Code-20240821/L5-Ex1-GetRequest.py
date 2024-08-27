import requests

x = requests.get("https://cdn.jsdelivr.net/npm/js-md5@0.7.3/build/md5.min.js")

print(x.text)

