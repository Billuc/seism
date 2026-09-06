import std/cmdline
import args as _
import conf as _
import cmd as _

var args = parseArgs(cmdline.commandLineParams())

var conf = parseConfFile(args.conffile)

case args.action
of "install":
  if evalCommand(conf.install) == 0:
    discard evalCommand(conf.postInstall)
