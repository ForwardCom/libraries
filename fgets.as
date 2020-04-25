/*********************************  fgets.as  *********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2020-04-25
* Version:       1.09
* Project:       ForwardCom library libc.li
* Description:   fgets function. Read string from file
* C declaration: char *fgets(char *str, int n, FILE *stream); 
*
* Copyright 2018-2020 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_fgets function public reguse = 7

sys_call(r0, r1, 1, 0x123)   // system call fgets. Buffer base r0, size r1
return

_fgets end

code end