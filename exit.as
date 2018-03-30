/*********************************  exit.as  **********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   exit function
* C declaration: void exit(int status); 
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_exit function public reguse = 0

sys_call(1, 0x10)            // system call exit. parameter in r0
filler                       // stop execution if the system call returns for some reason

_exit end

code end