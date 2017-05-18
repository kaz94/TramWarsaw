import requests
import json

url = 'https://api.um.warszawa.pl/api/action/wsstore_get/?id=c7238cfe-8b1f-4c38-bb4a-de386db7e776&apikey=b001b18d-f0fa-45e3-87e6-730e29a36ec5'

rsp = requests.get(url)

# check response status code
if (rsp.status_code == 200):
    print('Page retrieved successfully')
else:
    raise Exception("Bad status code")

jsonData = rsp.json()
jsonFileName = 'trams_file.txt'
with open(jsonFileName, 'w') as outfile:
    json.dump(jsonData, outfile)


'''

Beautiful Soup / Requests / lxml
Selenium - JavaScript pages - interactive for ex
Scrapy - major data crawling

##############################
# simpler:
import requests
page = requests.get('https://api.um.warszawa.pl/api/action/wsstore_get/?id=c7238cfe-8b1f-4c38-bb4a-de386db7e776&apikey=b001b18d-f0fa-45e3-87e6-730e29a36ec5')
contents = page.content
print(contents)

'''