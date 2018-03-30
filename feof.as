/*********************************  feof.as  **********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   feof function. Detect end of file
* C declaration: int feof(FILE *stream);
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_feof function public reguse = 1

sys_call(1, 0x115)   // system call feof
return

_feof end

code end