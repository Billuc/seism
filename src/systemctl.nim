import std/osproc
import ./conf

type CommandExit = tuple[output: string, exitCode: int] 

proc start(conf: Conf): CommandExit =
  return osproc.execCmdEx("systemctl start " & conf.name)

proc stop(conf: Conf): CommandExit =
  return osproc.execCmdEx("systemctl stop " & conf.name)

proc enable(conf: Conf): CommandExit =
  # TODO : create / update init.d file
  return osproc.execCmdEx("systemctl start " & conf.name)

proc disable(conf: Conf): CommandExit = 
  result = osproc.execCmdEx("systemctl disable " & conf.name)
  # TODO : delete init.d file

proc status(conf: Conf): CommandExit =
  return osproc.execCmdEx("systemctl status " & conf.name)

proc logs(conf: Conf, additionalArgs: string): CommandExit =
  return osproc.execCmdEx("journalctl --no-tail -t " & conf.name & " " & additionalArgs)
