/*********************************  fopen.as  *********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   fopen function. Open file
* C declaration: FILE *fopen(const char *filename, const char *mode); 
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_fopen function public reguse = 0x3

sys_call(1, 0x110)           // system call fopen
return

_fopen end

code end