# seism ideas

## Basic concept

- have one command to install, update, check status of packages based on conf files
- Update at a regular frequency. For example: daily, every Saturday at 4AM, monthly
- Have custom install, update, post install, post update & status commands in conf
- Log command and config. Could use journalctl
- Define CWD, environment, environment file
- Auto create a systemctl service and enable it

## Advanced features

- Additional systemctl options
- Extension system (for example for Git packages, packages hosted on Github, releases to curl)
- Extensions could work for different parts like define post update for astro projects
