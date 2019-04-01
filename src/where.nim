# =======
# Imports
# =======

import os
import net
import sequtils
import strutils
import strscans
import terminal
import parseopt
import nativesockets

# =====
# Types
# =====

type
  ColorFlagOptions = enum
    Auto,
    Always,
    Never

#

template color(color: untyped, body: untyped) =
  block:
    if display_color != Never:
      stdout.setForegroundColor(color)
    body
    if display_color != Never:
      stdout.resetAttributes()
# ===================
# * Main Entry Here *
# ===================

let hostname = getHostname()
let path = getCurrentDir()

#let depth = getEnv("SHLVL", "1").parseInt()
#let shell_level = sequtils.repeat(" ~>", depth)

let is_ssh = (existsEnv("SSH_CONNECTION") or existsEnv("SSH_CLIENT") or existsEnv("SSH_TTY"))

var display_color: ColorFlagOptions
var p = initOptParser()

for kind, key, value in p.getopt():
  case kind
  of cmdShortOption, cmdLongOption:
    case key
    of "c", "color": display_color = parseEnum[ColorFlagOptions](value, Auto)
    else: discard
  else: discard

if display_color == Auto:
  display_color =
    if isatty(stdout): Always
    else: Never

stdout.write("on ")
color(fgYellow):
  stdout.write(hostname)
if is_ssh:
 color(fgMagenta):
   stdout.write(" via ssh;")
stdout.write(" in ")
color(fgGreen):
  stdout.write(path)
stdout.write("\n")

