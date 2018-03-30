/*********************************  memcpy.as  ********************************
* Author:        Agner Fog
* date created:  2018-03-25
* Last modified: 2018-03-25
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   memcpy and memmove functions. Copy memory block
* C declaration: void *memcpy (void *dest, const void *src, uint64_t n)
* C declaration: void *memmove(void *dest, const void *src, uint64_t n)
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

// ! To do: Make vector read and write aligned for better performance

public _memcpy: function, reguse = 0x1F, 1
public _memmove: function, reguse = 0x1F, 1

code section execute align = 4

// r0 = destination
// r1 = source
// r2 = n
_memcpy function
_memmove:
int64 r3 = r0 - r1
if (uint64 r3 >= r2) {
   // destination will not overwrite source. copy forwards
   int64 r3 = r0 + r2                            // end of destination
   int64 r4 = r1 + r2                            // end of source
   // vector loop. count down r2
   for (int8 v0 in [r3-r2]) {
      int8 v0 = [r4-r2, length = r2]             // read from source
      int8 [r3-r2, length = r2] = v0             // write to destination
   }
}
else {
   // destination overlaps source. copy backwards
   push (r0)                                     // save destination
   int8  v0 = set_len(r2, v0)                    // length = min(n,maxlen)
   int64 r3 = get_len(v0)                        // this will be the block size
   int64 r0 = r0 + r2 - r3                       // last block of destination
   int64 r1 = r1 + r2 - r3                       // last block of source
   int64 r4 = r3                                 // current block size
   while (uint64 r2 > 0) {                       // loop counting down remaining bytes
      int8 v0 = [r1, length = r4]                // read from source
      int8 [r0, length = r4] = v0                // write to destination
      int64 r2 -= r4                             // subtract block size from remaining size
      uint64 r4 = min_u(r2, r3)                  // block size = minimum of remaining bytes and maxlen
      int64 r0 -= r4                             // subtract next block size from destination
      int64 r1 -= r4                             // subtract next block size from source
   }
   pop (r0)                                      // restore destination
}
return                                           // return dest in r0 unchanged
_memcpy end

code end