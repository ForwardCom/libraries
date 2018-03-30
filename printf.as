/*********************************  printf.as  **********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   printf function. Write a formatted data to console
* C declaration: int printf(const char *format, ...);
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_printf function public reguse = 3

sys_call(sp, sp, 1, 0x103)           // system call printf. full access to program memory
return

_printf end

code end