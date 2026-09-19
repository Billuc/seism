import std/cmdline

type Args* = object
  action*: string
  conffile*: string

proc parseArgs*(args: seq[string]): Args =
  var
    action: string
    conffile: string

  if args.len() <= 1:
    raise newException(Exception, "Insufficient number of arguments ! Expected: 2")

  action = args[0]
  conffile = args[1]

  return Args(action: action, conffile: conffile)
