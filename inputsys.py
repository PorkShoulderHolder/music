import termios, fcntl, sys, os
fd = sys.stdin.fileno()

oldterm = termios.tcgetattr(fd)
newattr = termios.tcgetattr(fd)
newattr[3] = newattr[3] & ~termios.ICANON & ~termios.ECHO
termios.tcsetattr(fd, termios.TCSANOW, newattr)

oldflags = fcntl.fcntl(fd, fcntl.F_GETFL)
fcntl.fcntl(fd, fcntl.F_SETFL, oldflags | os.O_NONBLOCK)

r_on = False
l_on = False

try:
    while 1:
        try:
            c = sys.stdin.read(1)
            if c == 'h' and l_on:
                l_on = not l_on
                os.system("echo l:::0 | nc -4u -w0 goodvibes.local 8888")
            elif c == 'h' and not l_on:
                l_on = not l_on
                os.system("echo l:::1000 | nc -4u -w0 goodvibes.local 8888")
            elif c == 'k' and r_on:
                r_on = not r_on
                os.system("echo r:::0 | nc -4u -w0 goodvibes.local 8888")
            elif c == 'k' and not r_on:
                r_on = not r_on
                os.system("echo r:::1000 | nc -4u -w0 goodvibes.local 8888")
        except IOError: pass
finally:
    termios.tcsetattr(fd, termios.TCSAFLUSH, oldterm)
    fcntl.fcntl(fd, fcntl.F_SETFL, oldflags)
