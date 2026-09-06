import std/syncio
import std/strscans
import std/strformat
import std/strutils

type Conf* = object
  name*: string
  install*: string
  postInstall*: string
  update*: string
  postUpdate*: string
  updateFrequency*: int
  healthCheck*: string

proc parseProperty(filepath: string, lineno: int, line: string, conf: var Conf): void =
  var key, value: string
  let trimmedLine = line.strip()

  if (trimmedLine.len() == 0):
    return

  if scanf(trimmedLine, "$w$s=$s$+$.", key, value):
    case key
    of "Install":
      conf.install = value
    of "PostInstall":
      conf.postInstall = value
    of "Update":
      conf.update = value
    of "PostUpdate":
      conf.postUpdate = value
    of "UpdateFrequency":
      try:
        conf.updateFrequency = parseInt(value)
      except:
        echo fmt"{filepath}:{lineno}: Could not parse value as a number"
    of "HealthCheck":
      conf.healthCheck = value
  else:
    echo fmt"{filepath}:{lineno}: Line doesn't respect the format KEY = VALUE !"

proc parseConfFile*(filepath: string): Conf =
  var
    f: File
    line: string
    inHeader: bool = true
    i: int = 0
    conf: Conf = Conf(
      name: "",
      install: "",
      postInstall: "",
      update: "",
      postUpdate: "",
      updateFrequency: 0,
      healthCheck: "",
    )

  if open(f, filepath):
    defer:
      f.close()
    conf.name = f.readLine()

    while f.readLine(line):
      if not inHeader:
        parseProperty(filepath, i, line, conf)
      if line == "---":
        inHeader = false
      i += 1

  return conf
