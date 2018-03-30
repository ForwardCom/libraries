/*********************************  strcat.as  ********************************
* Author:        Agner Fog
* date created:  2018-03-25
* Last modified: 2018-03-25
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   strcat function. Copy zero-terminated string src to the end of string dest
* C declaration: char *strcat(char *dest, const char *src)
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

extern _strlen: function, reguse = 0xF, 0x7
extern _memcpy: function, reguse = 0x1F, 1

code section execute align = 4

// r0 = destination
// r1 = source
_strcat function public reguse = 0xBF, 0x7
int64 r5 = r0                // save destination
int64 r4 = r1                // save source
call _strlen                 // length of destination
int64 r7 = r5 + r0           // end of destination
int64 r0 = r4
call _strlen                 // length of source
int64 r2 = r0 + 1            // add 1 for terminating zero
int64 r0 = r7
int64 r1 = r4
call _memcpy
int64 r0 = r5                // return destination
return
_strcat end

code end