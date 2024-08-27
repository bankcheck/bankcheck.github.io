import requests
import json

api_url = "https://data.etabus.gov.hk/v1/transport/kmb/route-stop"
response = requests.get(api_url)

responseinjson = response.json()
#print(response.json())
#{'type': 'Route', 'version': '1.0', 'generated_timestamp': '2021-08-24T12:40:13+08:00', 'data': {'route': '619', 'bound': 'I', 'service_type': '1', 'orig_en': 'CENTRAL (MACAU FERRY)', 'orig_tc': '中環(港澳碼頭)', 'orig_sc': '中环(港澳码头)', 'dest_en': 'SHUN LEE', 'dest_tc': '順利', 'dest_sc': '顺利'}}

#print(responseinjson['data'])

data = responseinjson['data']
stationDict = {}

for item in data:
    if item['route'] == "1":
        station = item['stop']
        stop_url = "https://data.etabus.gov.hk/v1/transport/kmb/stop/" + station
        response_station = requests.get(stop_url)
        json_station = response_station.json()
        stationDict[station] = json_station['data']['name_tc']

print(stationDict)
