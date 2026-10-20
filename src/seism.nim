import std/cmdline
import args as _
import conf as _
import cmd as _
import frequencyParser
import std/strformat
import std/logging
import std/os

var logger = newConsoleLogger()
logging.addHandler(logger)

when isMainModule:
  var args = parseArgs(cmdline.commandLineParams())

  var conf = parseConfFile(args.conffile)

  case args.action
  of "install":
    if evalCommand(conf.install) == 0:
      quit(evalCommand(conf.postInstall))
  of "update":
    if evalCommand(conf.update) == 0:
      quit(evalCommand(conf.postUpdate))
  of "health":
    if evalCommand(conf.healthCheck) == 0:
      echo "Healthy !"
    else:
      echo "Not healthy :("
  of "info":
    echo conf.name
    echo ""
    echo conf.description
    echo ""
    conf.updateFrequency.printRepetition()
  of "start":
    runCommandInBg(conf.start)
    echo fmt"Service started ! Check it is correctly running using this command: seism health {args.conffile}"
  of "stop":
    if evalCommand(conf.stop) == 0:
      echo "Stopped !"
    else:
      echo fmt"Could not stop service {conf.name}"
  of "restart":
    if evalCommand(conf.stop) == 0:
      runCommandInBg(conf.start)
    else:
      echo fmt"Could not stop service {conf.name}"
  else:
    echo "Unknown action: " & args.action
