/*********************************  fflush.as  ********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   fflush function. Flush file
* C declaration: int fflush(FILE *stream); 
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_fflush function public reguse = 1

sys_call(1, 0x114)   // system call fflush
return

_fflush end

code end