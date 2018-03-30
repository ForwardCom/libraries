/*********************************  fseek.as  *********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   fseek function. Set current position of file
* C declaration: int fseek(FILE *stream, long int offset, int whence);
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_fseek function public reguse = 7

sys_call(1, 0x117)   // system call fseek
return

_fseek end

code end