/*********************************  fgetc.as  *********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   fgetc function. Read single character from file
* C declaration: int fgetc(FILE *stream); 
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_fgetc function public reguse = 1

sys_call(1, 0x121)   // system call fgetc
return

_fgetc end

code end