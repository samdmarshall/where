import os
import posix
import parseopt
import strutils
import terminal

addQuitProc(resetAttributes)

var disable_color = false

var parser = initOptParser()
for kind, key, value in parser.getopt():
  case kind
  of cmdLongOption, cmdShortOption:
    case key
    of "no-color":
      disable_color = true
    else:
      discard
  else:
    discard

var hostname = " ".repeat(255)
let length =  gethostname(hostname, 255)
hostname = hostname.split(".local")[0].strip()

let path = getCurrentDir()

var modifier = " in "
if existsEnv("SSH_CONNECTION"):
  modifier = " via ssh; in "

if disable_color:
  stdout.write("on " & hostname & modifier & path & "\n")
else:
  stdout.write("on ")
  stdout.setForegroundColor(fgYellow)
  stdout.write(hostname)
  stdout.resetAttributes()
  stdout.write(modifier)
  stdout.setForegroundColor(fgGreen)
  stdout.write(path)
  stdout.write("\n")

