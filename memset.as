/*********************************  memset.as  ********************************
* Author:        Agner Fog
* date created:  2018-03-25
* Last modified: 2021-04-25
* Version:       1.11
* Project:       ForwardCom library libc.li
* Description:   memcpy and memmove functions. Copy memory block
* C declaration: void *memset(void *str, int8_t value, uint64_t n)
*
* Copyright 2018-2021 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

public _memset: function, reguse = 0xF, 1

code section execute align = 4

// r0 = destination
// r1 = int8 value
// r2 = n
_memset function

// broadcast value into vector
int8 v0 = gp2vec(r1)
int8 v0 = broad(v0, r2) // broadcast value into vector of desired length or maximum length

if (uint64 r2 <= 8) {  
   // small size. do it all at once
   int8 [r0, length = r2] = v0
   return
}
// point to end of vector
int64 r1 = r0 + r2

// align destination by 8 for efficiency
int8  r3 = -r0
int8+ r3 &= 7
if (int8+ r3 != 0) {
   int8  [r0, length = r3] = v0
   int64 r2 -= r3
}
// do the rest as vector loop
for (int8 v0 in [r1-r2]) {
   int8 [r1-r2, length = r2] = v0
}
// return str1 in r0 unchanged
return
_memset end

code end