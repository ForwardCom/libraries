/****************************  divide_int_light.as **************************
* Author:        Agner Fog
* date created:  2021-05-26
* Last modified: 2021-05-26
* Version:       1.11
* Project:       ForwardCom library libc_light.li
* Description:   divide_int: divide two 32-bit signed integers
* This function is for small CPUs with limited capabilities and no division 
* instruction. It returns the quotient and the remainder.
* Returns INT_MIN if dividing by zero.
*
* Copyright 2021 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/


code section execute 

_divide_int function public reguse=3,0
  // divide two 32 bit signed integers. return quotient and remainder
  // input r0: dividend
  // input r1: divisor
  // output r0: r0 / r1
  // output r1: r0 % r1

  if (int32 r1 == 0) {jump divide_error} // check for division by 0

  // save r2 - r5
  int64 sp -= 4*8
  int64 [sp+0x00] = r2
  int64 [sp+0x08] = r3
  int64 [sp+0x10] = r4
  int64 [sp+0x18] = r5

  // get signs
  int32 r2 = r0 < 0                    // sign of r0
  int32 r0 = -r0, mask = r2            // abs(r0)
  int32 r3 = r1 < 0                    // sign of r1
  int32 r1 = -r1, mask = r3            // abs(r1)
  int r3 ^= r2                         // sign of result
  int r2 = 0                           // quotient calcuated in r2
  int r4 = bitscan(r0, 1)              // number of significant bits in dividend
  int r5 = bitscan(r1, 1)              // number of significant bits in divisor
  if (int r4 >= r5) {
    // division loop
    int r4 -= r5                       // approximate number of significant bits in quotient
    int r1 <<= r4                      // shift left divisor
    do {                               // loop r4 + 1 times
      uint32 r5 = r0 >= r1             // one bit of quotient
      int32 r0 -= r1, mask = r5        // subtract if bigger
      int32 r2 <<= 1                   // shift left quotient
      int32 r2 |= r5                   // add new bit
      uint32 r1 >>= 1                  // shift right divisor
      int r4--                         // loop counter
    } while (int r4 >= 0)
  }
  // quotient = r2, remainder = r0
  int32 r1 = r3 ? -r0 : r0             // apply sign to remainder
  int32 r0 = r3 ? -r2 : r2             // apply sign to quotient

  // restore r2 - r5
  int64 r2 = [sp+0x00]
  int64 r3 = [sp+0x08]
  int64 r4 = [sp+0x10]
  int64 r5 = [sp+0x18]
  int64 sp += 4*8
  return

  divide_error:                        // division by zero
  int32 r0 = 0x80000000                // return INT_MIN
  int32 r1 = 0
  return

code end