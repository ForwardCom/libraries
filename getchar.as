/*********************************  getchar.as  *******************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   getchar function. Read single character from stdin
* C declaration: int getchar(void); 
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_getchar function public reguse = 1

sys_call(1, 0x120)   // system call getchar
return

_getchar end

code end