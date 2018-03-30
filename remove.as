/*********************************  remove.as  ********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   remove function. Delete file
* C declaration: int remove(const char *filename); 
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_remove function public reguse = 1

sys_call(1, 0x140)           // system call remove
return

_remove end

code end