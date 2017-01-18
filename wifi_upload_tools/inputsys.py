import termios, fcntl, sys, os
import socket

fd = sys.stdin.fileno()

oldterm = termios.tcgetattr(fd)
newattr = termios.tcgetattr(fd)
newattr[3] = newattr[3] & ~termios.ICANON & ~termios.ECHO
termios.tcsetattr(fd, termios.TCSANOW, newattr)

oldflags = fcntl.fcntl(fd, fcntl.F_GETFL)
fcntl.fcntl(fd, fcntl.F_SETFL, oldflags | os.O_NONBLOCK)

r_on = False
l_on = False

target_addr = sys.argv[1]
port =  8888

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

def netcat_sendp(on, p, ta):
    os.system("echo l:::0 | nc -4u -w0 {0} 8888".format(target_addr))

def sock_send(contents):
    sock.sendto(contents, (target_addr, port))



try:
    while 1:
        try:
            c = sys.stdin.read(1)
            if c == 'h' and l_on:
                l_on = not l_on
                sock_send("l:::0")
            elif c == 'h' and not l_on:
                l_on = not l_on
                sock_send("l:::1")
            elif c == 'k' and r_on:
                r_on = not r_on
                sock_send("r:::0")
            elif c == 'k' and not r_on:
                r_on = not r_on
                sock_send("r:::1")
        except IOError: pass
finally:
    termios.tcsetattr(fd, termios.TCSAFLUSH, oldterm)
    fcntl.fcntl(fd, fcntl.F_SETFL, oldflags)
