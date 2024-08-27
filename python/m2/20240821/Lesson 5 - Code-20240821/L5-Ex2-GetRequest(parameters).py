import requests

#payload = {'key1': 'value1', 'key2': 'value2'}
payload = {"keywordForQuickSearch": "programmer"}

x = requests.get("https://www.ctgoodjobs.hk/ctjob/listing/joblist.asp", params=payload)
#https://www.ctgoodjobs.hk/ctjob/listing/joblist.asp?keywordForQuickSearch=programmer

print(x.url)
print(x.text)

