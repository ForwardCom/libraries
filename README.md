# libraries
ForwarcCom function libraries:

## libc.li
Contains the most important C standard functions.

Additional functions specific for ForwardCom include default program startup code and event handler.

## math.li
Standard mathematical functions.
Current functions include sin, cos, tan, sincos, integrate.

More functions will be added later.

## libc_light.li
Lean version of libc.li for small softcores without system call.

##

Files included |  Description
--- | ---
*.as    |      Assembly source code   
*.li      |      ForwardCom function library
libraries.make  |     Makefile for these function libraries
makelib.bat |     Example Windows bat file for making libraries
