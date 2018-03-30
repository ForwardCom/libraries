/*********************************  fwrite.as  ********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2018-03-21
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   fwrite function. Write to file
* C declaration: size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4

_fwrite function public reguse = 0xF

int64 r1 *= r2               // calculate total size
int64 r2 = 1                 // make r1*r2 unchanged

sys_call(r0, r1, 1, 0x113)   // system call fwrite. buffer base r0, size r1
return

_fwrite end

code end