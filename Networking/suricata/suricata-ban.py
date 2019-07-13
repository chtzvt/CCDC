#!/usr/bin/env python
import re, struct, os, time, requests, json
# `apt-get install python-mysqldb` or `yum install mysql-python`


# HIGH = 1, MED = 2, LOW = 3

max_priority = 2
safe_list = [
	# Example: Match 192.168.14.27 - 192.168.14.32 and 192.168.14.210
	r'192.168.14.(2[7-9]|3[0-2])'
	#,r'192.168.14.210'
]


def safe_ip(ip_str):
	safe_re = r'^(%s)$' % '|'.join(safe_list)
	return re.match(safe_re, ip_str)

def ip_decode(ip_num):
	return ".".join(str(ord(b)) for b in struct.pack(">I", ip_num))

def ban_ip(ip_str, timestamp):
	#ip_str = ip_decode(ip_num)
	if safe_ip(ip_str): return
	
	print("[%s] Banning %s!\a" % (timestamp, ip_str))
	tup = (ip_str, timestamp)
	os.system("iptables -I FORWARD -s %s -m comment --comment '%s' -j DROP" % tup)
	os.system("iptables -I FORWARD -d %s -m comment --comment '%s' -j DROP" % tup)

def get_new_alerts(last_timestamp):
        #url for elasticsearch query endpoint
        url = "http://127.0.0.1:9200/_search?pretty"
        data = {"query": 
                   {"bool": 
                       {"must": 
                           [
                               {"range": 
                                   {"timestamp": 
                                       {"gt": last_timestamp}}
                               }, 
                               {"range": 
                                   {"alert.severity": 
                                       {"gte": 0, "lte": max_priority}}
                               }
                           ]
                        }
                    }
                }


        r = requests.post(url, data= json.dumps(data))
        
	return r.json()["hits"]["hits"]

def get_last_timestamp():
	timestamp = "0"
	try:
		fp = open("timestamp.txt", "r")
		timestamp = fp.read()
		fp.close()
	finally:
		return timestamp

def set_last_timestamp(timestamp):
	try:
		fp = open("timestamp.txt", "w")
		fp.write(timestamp)
		fp.close()
	except Exception, e:
		print("Error writing timestamp: %s" % e)

def ban_attackers():
	last_timestamp = get_last_timestamp()
	for alert in get_new_alerts(last_timestamp):
		timestamp = alert["_source"]["timestamp"]
		ban_ip(alert["_source"]["src_ip"], timestamp)
		ban_ip(alert["_source"]["dest_ip"], timestamp)
		last_timestamp = max(last_timestamp, timestamp)
	
	set_last_timestamp(last_timestamp)

if __name__ == "__main__":
	while True:
		ban_attackers()
		time.sleep(5)
