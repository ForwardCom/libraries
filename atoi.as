/*********************************  atoi.as ***********************************
* Author:        Agner Fog
* date created:  2018-03-23
* Last modified: 2018-03-23
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   atoi: convert string to integer
* C declaration: int64_t atoi(const char * str)
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

code section execute align = 4                   // code section

_atoi function public reguse = 0x1F, 0

int32+ r1 = 0                                    // state:  0: after whitespace
                                                 //         1: after +/-
                                                 //         2: after digit
int64  r2 = 0                                    // value
int8+  r3 = 0                                    // sign
int8   r4 = [r0]                                 // read first character from string
// loop through string until terminating zero
while (int8+ r4 != 0) {
   if (uint8+ r4 <= ' ') {                       // whitespace
      if (int32+ r1 != 0) {jump ERROREND}        // space not allowed if state != 0. end of number
      jump NEXT                                  // else
   }
   if (uint8+ r4 <= '-') {                       // '+' or '-'
      if (int32+ r1 != 0) {jump ERROREND}        // sign not allowed if state != 0. end of number
      int32+ r1 = 1                              // state = 1
      if (uint8+ r4 == '-') {
         int8+ r3 = 1                            // sign
         jump NEXT                               // else
      }
      if (uint8+ r4 != '+') {
         jump ERROREND                           // anything else than '+'. end of number
      }
   }
   else {
      int8+ r4 -= '0'                            // subtract ASCII '0'
      if (uint8+ r4 > 9) {jump ERROREND}         // anything else than 0-9. end of number
      int64 r2 *= 10                             // value * 10
      int64 r2 += r4                             // + digit
      int32+ r1 = 2                              // state = 2
   }
   NEXT:
   int64 r0++                                    // point to next character
   int8 r4 = [r0]                                // read next character from string
}
ERROREND:                                        // jump here when a character that cannot be part of the string is met
int64 r0 = r3 ? -r2 : r2                         // change sign if r3
return

_atoi end

code end