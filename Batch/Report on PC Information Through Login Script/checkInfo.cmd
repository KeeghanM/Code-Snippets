@ECHO OFF

findstr /LI %1 \\192.168.0.218\NETLOGON\login_log.txt | tail -5
