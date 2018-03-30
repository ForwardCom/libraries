/*********************************  time.as  **********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   time function. Get time in seconds
* C declaration: time_t time(time_t *timer);
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_time function public reguse = 1

sys_call(1, 0x020)           // system call time
return

_time end

code end