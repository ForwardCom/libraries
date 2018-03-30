/*********************************  strcpy.as  ********************************
* Author:        Agner Fog
* date created:  2018-03-25
* Last modified: 2018-03-25
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   strcpy function. Copy zero-terminated string
* C declaration: char *strcpy(char *dest, const char *src)
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

extern _strlen: function, reguse = 0xF, 0x7
extern _memcpy: function, reguse = 0x1F, 1

code section execute align = 4

// r0 = destination
// r1 = source
_strcpy function public reguse = 0x1F, 0x7
push (r0, r1)                // save source and destination
int64 r0 = r1
call _strlen                 // length of source
int64 r2 = r0 + 1            // length including terminating zero
pop (r1, r0)
jump _memcpy                 // tail call. return dest in r0 unchanged
_strcpy end

code end