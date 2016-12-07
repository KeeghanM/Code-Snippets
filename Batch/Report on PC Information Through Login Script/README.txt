Place the loginLog.cmd and logoffLog.cmd files into the NETLOGON folder of the DC.
Set them to run in the group policy

checkInfo.cmd, TAIL.exe and CYGWIN.dll can be placed anywhere. Then just run checkInfo.cmd from a command prompt with a username as the variable.
Will return the last 5 log entries for that user