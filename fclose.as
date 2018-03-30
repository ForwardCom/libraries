/*********************************  fclose.as  ********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   fclose function. Close file
* C declaration: int fclose(FILE *stream);
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_fclose function public reguse = 0x3

sys_call(1, 0x111)           // system call fclose
return

_fclose end

code end