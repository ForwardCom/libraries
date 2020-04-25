rem makelib.bat
rem Author:        Agner Fog
rem date created:  2018-03-21
rem Description:   batch file for making ForwardCom libraries under Windows

rem Set path to gnu make and forw.exe
path %path%;C:\cygwin64\bin;C:\1_Public\ForwardCom\forw\x64\Release

make libc.li math.li

pause