/****************************  multiply_int_light.as **************************
* Author:        Agner Fog
* date created:  2021-05-26
* Last modified: 2021-05-26
* Version:       1.11
* Project:       ForwardCom library libc_light.li
* Description:   multiply_int: multiply two 32-bit signed integers
* This function is for small CPUs with limited capabilities and no multiplication instruction
*
* Copyright 2021 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/


code section execute 

_multiply_int function public reguse=1,0
  // multiplies two 32 bit signed integers. no overflow check
  // input r0, r1: factors

  // save r1, r2, r3
  int64 sp -= 3*8
  int64 [sp] = r1
  int64 [sp+8] = r2
  int64 [sp+0x10] = r3

  // get signs
  int32 r2 = r0 < 0                    // sign of r0
  int32 r0 = -r0, mask = r2            // abs(r0)
  int32 r3 = r1 < 0                    // sign of r1
  int32 r1 = -r1, mask = r3            // abs(r1)
  int r3 ^= r2                         // sign of product
  // get the smallest factor in r1
  if (uint32 r1 > r0) {
    int32 r2 = r1
    int32 r1 = r0
    int32 r0 = r2
  }
  int32 r2 = 0                         // summation of r0 multiplied by each bit in r1
  while (int32 r1 != 0) {              // multiplication loop
    uint32 r2 += r0, mask = r1         // add r0 if bit 0 of r1
    uint32 r1 >>= 1
    uint32 r0 <<= 1
  }
  int32 r0 = r3 ? -r2 : r2             // apply sign

  // restore r2, r3
  int64 r1 = [sp]
  int64 r2 = [sp+8]
  int64 r3 = [sp+0x10]
  int64 sp += 3*8
  return

code end