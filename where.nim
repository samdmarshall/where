import os
import posix
import strutils
import terminal

addQuitProc(resetAttributes)

var hostname = " ".repeat(255)
let length =  gethostname(hostname, 255)
hostname = hostname.split(".local")[0]

let path = getCurrentDir()

var modifier = " in "
if existsEnv("SSH_CONNECTION"):
  modifier = " via ssh; in "

stdout.write("on ")
stdout.setForegroundColor(fgYellow)
stdout.write(hostname)
stdout.resetAttributes()
stdout.write(modifier)
stdout.setForegroundColor(fgGreen)
stdout.write(path)
stdout.write("\n")

