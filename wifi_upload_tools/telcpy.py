#!/usr/bin/python

import telnetlib
import sys
import time
tn = telnetlib.Telnet(sys.argv[1])
print "connected"
time.sleep(2)
tn.write("\n")
tn.read_until("> ")
tn.write("file.open('{0}', 'w')".format(sys.argv[3]))
time.sleep(0.2)
tn.write("\n")
tn.read_until("> ")
print "opened remote file"
with open(sys.argv[2]) as f:
    print "opened local file"
    for line in f.read().split("\n"):
        s = 'file.write(\'{0}\\n\')'.format(line.strip())
        tn.write(s)

        tn.read_until("> ")
        print "wrote " + s

tn.write("file.close()")
print "completed"
