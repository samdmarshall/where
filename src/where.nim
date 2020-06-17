
# =======
# Imports
# =======

import os
import net
import sequtils
import strutils
import strscans
import terminal
import strformat
import nativesockets

import commandeer

# =====
# Types
# =====

type
  ColorFlagOptions = enum
    Auto,
    Always,
    Never

# =========
# Constants
# =========

const
  NimblePkgVersion {.strdefine.} = ""
  NimblePkgName {.strdefine.} = ""

# =========
# Templates
# =========

template color(color: untyped, body: untyped) =
  block:
    if display_color != Never:
      stdout.setForegroundColor(color)
    body
    if display_color != Never:
      stdout.resetAttributes()

# ==========
# Main Entry
# ==========

proc main() =
  var hostname = getHostname()
  hostname.removeSuffix(".local")
  let path = getCurrentDir()
  let user = getEnv("USER")

  let depth = getEnv("SHLVL", "1").parseInt()
  let shell_level = sequtils.repeat(" ~>", depth)

  let is_ssh = (existsEnv("SSH_CONNECTION") or existsEnv("SSH_CLIENT") or existsEnv("SSH_TTY"))

  commandline:
    option ColorFlag, string, "color", "c", "auto"
    exitoption "version", "v", fmt"{NimblePkgName} v{NimblePkgVersion}"
    exitoption "help", "h", fmt"{NimblePkgName} [-h|--help] [-v|--version] [-c|--color:<auto|always|never>]"

  var display_color = parseEnum[ColorFlagOptions](ColorFlag)

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
  stdout.write(" as ")
  color(fgRed):
    stdout.write(user)
  stdout.write(" in ")
  color(fgGreen):
    stdout.write(path)
  stdout.write("\n")
  color(fgRed):
    stdout.write(shell_level)
#  stdout.write("\n")

when isMainModule:
  main()
