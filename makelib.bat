rem makelib.bat
rem Author:        Agner Fog
rem date created:  2018-03-21
rem last modified: 2021-05-16
rem Description:   batch file for making ForwardCom libraries under Windows

copy ..\forw\instruction_list.csv .\

rem Set path to gnu make and forw.exe
path %path%;C:\cygwin64\bin;C:\_Public\ForwardCom\forw\x64\Release

make -f libraries.make libc.li math.li libc_light.li

pause