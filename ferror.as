/*********************************  ferror.as  ********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   ferror function. Get error indicator from file
* C declaration: int ferror(FILE *stream);
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_ferror function public reguse = 1

sys_call(1, 0x118)   // system call ferror
return

_ferror end

code end