/*********************************  fprintf.as  *******************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   fprintf function. Write a formatted data to a file
* C declaration: int fprintf(FILE *stream, const char *format, ...);
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_fprintf function public reguse = 7

sys_call(sp, sp, 1, 0x104)           // system call fprintf. full access to program memory
return

_fprintf end

code end