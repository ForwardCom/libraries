/***************************  print_hexadecimal_light.as **********************
* Author:        Agner Fog
* date created:  2021-05-16
* Last modified: 2021-05-16
* Version:       1.11
* Project:       ForwardCom library libc_light.li
* Description:   puts: print a string to stdout. Does not append linefeed
* This version is for CPUs with limited capabilities
* C declaration: void print_hexadecimal(uint64_t h);
*
* Copyright 2021 GNU General Public License http://www.gnu.org/licenses
******************************************************************************/

code section execute align = 4                   // code section

// Print a hexadecimal number to stdout

_print_hexadecimal function public reguse=3,0

// save r2-r3
int64 sp -= 2*8
int64 [sp]      = r2
int64 [sp+8]    = r3

int64 r1 = bitscan(r0, 1)              // find number of bits
uint32 r1 >>= 2
uint32 r1++                            // number of digits to print
if (int r1 > 8) {                      // must use 64 bits
    int r2 = 16 - r1                   // number of digits to skip
    int r2 <<= 2                       // number of bits to skip
    uint64 r0 <<= r2                   // remove leading zeroes
    for (int ; r1 > 0; r1--) {         // loop r1 times
        uint64 r0 = rotate(r0, 4)      // get digit into low position
        int r2 = r0 & 0xF              // get digit
        int r2 += '0'                  // convert to ASCII
        int r3 = r2 > '9'              // digit is A - F
        int r2 = r3 ? r2 + 7 : r2      // add 7 to get letter
        int8 output(r2, r2, 10);       // output digit
    }
}
else {                                 // use 32 bits. CPU may not support 64 bits
    int r2 = 8 - r1                    // number of digits to skip
    int r2 <<= 2                       // number of bits to skip
    uint32 r0 <<= r2                   // remove leading zeroes
    for (int ; r1 > 0; r1--) {         // loop r1 times
        uint32 r0 = rotate(r0, 4)      // get digit into low position
        int r2 = r0 & 0xF              // get digit
        int r2 += '0'                  // convert to ASCII
        int r3 = r2 > '9'              // digit is A - F
        int r2 = r3 ? r2 + 7 : r2      // add 7 to get letter
        int8 output(r2, r2, 10);       // output digit
    }
}

// restore r2-r3
int64 r2 = [sp]
int64 r3 = [sp+8]
int64 sp += 2*8

return
_print_hexadecimal end


code end