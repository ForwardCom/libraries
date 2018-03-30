/*********************************  ftell.as  *********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   ftell function. Get current position of file
* C declaration: long int ftell(FILE *stream);
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_ftell function public reguse = 1

sys_call(1, 0x116)   // system call ftell
return

_ftell end

code end