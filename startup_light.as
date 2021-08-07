/*********************************  startup_light.as  *************************
* Author:        Agner Fog
* date created:  2018-03-22
* Last modified: 2021-05-26
* Version:       1.11
* Project:       ForwardCom library libc_light.li
* Description:   startup: program initialization
* C declaration: void _entry_point(int argc, char *argv[], char *envp[])
*
* This is the default startup code for ForwardCom programs. 
* This is a light version for small systems. It does not call global
* constructors and destructors, but just calls _main
*
* Copyright 2018-2021 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/
code section execute align = 4

extern _main: function reguse = 0xFFFFFFFF,0xFFFFFFFF

// execution starts here:
__entry_point function public reguse = 0xFFFFFFFF,0xFFFFFFFF

call _main                             // call main, the user program

sys_call(1, 0x10)                      // system call exit
filler                                 // make sure execution stops if the system call returns for some reason

__entry_point end

code end