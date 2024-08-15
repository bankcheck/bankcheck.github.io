import requests
import json

api_url = "https://data.etabus.gov.hk/v1/transport/kmb/route/619/inbound/1"
response = requests.get(api_url)

responseinjson = response.json()
#print(response.json())
#{'type': 'Route', 'version': '1.0', 'generated_timestamp': '2021-08-24T12:40:13+08:00', 'data': {'route': '619', 'bound': 'I', 'service_type': '1', 'orig_en': 'CENTRAL (MACAU FERRY)', 'orig_tc': '中環(港澳碼頭)', 'orig_sc': '中环(港澳码头)', 'dest_en': 'SHUN LEE', 'dest_tc': '順利', 'dest_sc': '顺利'}}

print(responseinjson)
print(responseinjson['data'])
print(responseinjson['data']['dest_tc'])
