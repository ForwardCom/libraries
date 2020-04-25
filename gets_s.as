/*********************************  gets_s.as  ********************************
* Author:        Agner Fog
* date created:  2018-03-23
* Last modified: 2020-04-25
* Version:       1.09
* Project:       ForwardCom library libc.li
* Description:   gets_s function. Read string from stdin
* C declaration: char *gets_s(char *str, int n); 
*
* Copyright 2018-2020 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_gets_s function public reguse = 3

sys_call(r0, r1, 1, 0x124)   // system call gets_s. Buffer base r0, size r1
return

_gets_s end

code end