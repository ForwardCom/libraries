/*********************************  strlen.as  ********************************
* Author:        Agner Fog
* date created:  2018-03-25
* last modified: 2023-01-01
* Version:       1.12
* Project:       ForwardCom library libc.li
* Description:   strlen function. Find length of zero-terminated string
* C declaration: int64_t strlen(const char * str)
*
* Copyright 2018-2023 GNU General Public License http://www.gnu.org/licenses

// NOTE: Not up to date !!
*****************************************************************************/

%data_extra_space = 0x100                        // maximum length we are allowed to read beyond a string

code section execute align = 4

_strlen function public reguse = 0xF, 0x7
// r0 = str
// start at nearest preceding 8 bytes boundary for efficiency
int64 r1 = r0 & -8                               // 8-bytes boundary
int64 r2 = r0 - r1                               // length of unused part
int64 r3 = data_extra_space                      // maximum allowed length
int64 v0 = 0                                     // zero
int8  v0 = set_len(v0, r3)                       // make a zero vector with length = min(data_extra_space, max_vector_length)
int64 r3 = get_len(v0)                           // this vector length will be used
int8  v1 = mask_length(v0, r2, 0), options=1     // mask off unused part
int8  v2 = [r1, length = r3]                     // read vector
int8  v2 = v1 ? (v0 == v2) : v0                  // compare with 0, masked
int8  v1 = bool_reduce(v2, 2)                    // horizontal OR is in bit 1
// loop as long as no zero is found
while (float !(v1 & 1)) {                        // (specify float to get vector register)
   int64 r1 += r3                                // next block of maximum length
   int8 v2 = [r1, length = r3]                   // read vector
   int8 v2 = (v0 == v2)                          // compare with 0, no mask now
   int8 v1 = bool_reduce(v2, 2)
}
int8 v2 = bool2bits(v2)                          // bit index to the end of the string
int64 r3 = -1                                    // will be zero in first iteration of loop below
BIT64_LOOP:                                      // do while (v1 == 0):
   int64 r3++                                    // point to 64-bit block of v2
   int64 v1 = extract(v2, r3)                    // extract 64 bits from vector v2
double v1 = and(v1, v1), jump_zero BIT64_LOOP    // loop while v1 is zero
int64 r2 = vec2gp(v1)                            // transfer to general purpose register
int64 r2 = bitscan(r2, 0)                        // get index to first byte
int64 r3 <<= 6                                   // r3 << 6
int64 r2 += r3                                   // 
// add difference between current block start and string start
int64 r0 = r2 + r1 - r0                          // the string length is returned in r0
return
_strlen end

code end