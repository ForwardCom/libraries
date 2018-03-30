/*********************************  startup.as  *******************************
* Author:        Agner Fog
* date created:  2018-03-22
* Last modified: 2018-03-22
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   startup: program initialization
* C declaration: void _entry_point(int argc, char *argv[], char *envp[])
*
* This is the default startup code for ForwardCom programs. 
* It will be linked into a program if there is no definition of __entry_point elsewhere.
* It will do the following:
* 1. call any constructor event handlers
* 2. call _main
* 3. call any destructor event handlers
* 4. exit with the return code from _main
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

// define event IDs
%EVT_CONSTRUCT = 1           // call static constructors and initialization procedures before calling main
%EVT_DESTRUCT  = 2           // call static destructors and clean up after return from main

code section execute align = 4

extern _main: function reguse = 0xFFFFFFFF,0xFFFFFFFF
extern _raise_event: function

// execution starts here:
__entry_point function public reguse = 0xFFFFFFFF,0xFFFFFFFF

// parameters to main: int argc, char *argv[], char *envp[]
int64 r16 = r0
int64 r17 = r1
int64 r18 = r2

// call any constructors before main
int64 r0 = EVT_CONSTRUCT << 32                   // constructor event
call _raise_event                                // call event handlers for constructors

// restore the parameters to main
int64 r0 = r16
int64 r1 = r17
int64 r2 = r18

// call main, the user program
call _main
int64 r16 = r0                                   // save the return value

// call destructors after main
int64 r0 = EVT_DESTRUCT << 32                    // destructor event
call _raise_event                                // call event handlers for destructors

int64 r0 = r16                                   // return value from main to the operating system
sys_call(1, 0x10)                                // system call exit
filler                                           // make sure execution stops if the system call returns for some reason

__entry_point end

code end