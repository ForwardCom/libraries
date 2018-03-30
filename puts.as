/*********************************  puts.as  **********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   puts function. Write a zero-terminated string to console
* C declaration: int puts(const char *str);
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_puts function public reguse = 1

sys_call(sp, sp, 1, 0x101)           // system call puts. full access to program memory
return

_puts end

code end