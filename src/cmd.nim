import std/osproc

type Command* = object
  command*: string
  arguments*: seq[string]

proc exec*(cmd: Command): int =
  let process = osproc.startProcess(
    cmd.command, "", cmd.arguments, nil, {poUsePath, poStdErrToStdOut}
  )
  let (lines, exitCode) = process.readLines()

  for l in lines:
    echo l

  process.close()
  return exitCode

proc evalCommand*(command: string): int =
  let process = osproc.startProcess(
    command, "", [], nil, {poUsePath, poEvalCommand, poStdErrToStdOut}
  )
  let (lines, exitCode) = process.readLines()

  for l in lines:
    echo l

  process.close()
  return exitCode
