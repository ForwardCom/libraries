/*********************************  abort.as  **********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   abort function
* C declaration: void abort(void);
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_abort function public reguse = 0

sys_call(1, 0x11)            // system call abort. no parameter
filler                       // stop execution if the system call returns for some reason

_abort end

code end