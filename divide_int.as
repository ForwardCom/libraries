/****************************  divide_int.as ********************************
* Author:        Agner Fog
* date created:  2021-05-26
* Last modified: 2021-08-03
* Version:       1.11
* Project:       ForwardCom library libc.li
* Description:   divide_int: divide two 32-bit signed integers
* This function is for compatability with libc_light.li. 
* It returns the quotient and the remainder of r0 / r1
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

  if (int32 r1 != 0) {  
      int32  r2 = r0 / r1
      int32  r1 = r0 % r1
      int32  r0 = r2
      return
  }
  // return INT_MIN if error
  int32 r0 = 0x80000000
  int32 r1 = 0
  return

code end