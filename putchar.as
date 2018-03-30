/*********************************  putchar.as  **********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   putchar function. Write a single character to console
* C declaration: int putchar(int char);
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_putchar function public reguse = 1

sys_call(sp, sp, 1, 0x102)           // system call putchar
return

_putchar end

code end