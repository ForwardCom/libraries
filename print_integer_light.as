/***************************  print_integer_light.as **************************
* Author:        Agner Fog
* date created:  2021-05-16
* Last modified: 2021-05-16
* Version:       1.11
* Project:       ForwardCom library libc_light.li
* Description:   puts: print a string to stdout. Does not append linefeed
* This version is for CPUs with limited capabilities
* C declaration: void print_integer(int32_t i);
* C declaration: void print_unsigned(uint32_t i);
*
* Copyright 2021 GNU General Public License http://www.gnu.org/licenses
******************************************************************************/

code section execute align = 4                   // code section

// Print a 32-bit signed integer as decimal number to stdout
_print_integer function public reguse=3,0

if (int32 r0 < 0) {
    int32 r0 = -r0
    int8+ r1 = '-'
    int8 output(r1, r1, 10)  // print '-'
}
// continue in _print_unsigned

// Print a 32-bit unsigned integer as decimal number to stdout
_print_unsigned function public reguse=3,0

// This function is using the double dabble algorithm for binary to BCD conversion.
// This method is slow, but it is used here because it does not require division
// or multiplication. This makes sure it will work on small cores without mul and div instructions.

// save r2-r5
int64 sp -= 4*8
int64 [sp]      = r2
int64 [sp+8]    = r3
int64 [sp+0x10] = r4
int64 [sp+0x18] = r5

// First two BCD digits are made with simple subtraction to avoid the need for a larger bit field
int r5 = 0
while (uint32 r0 >= 1000000000) {
    uint32 r0 -= 1000000000
    uint32 r5 += 0x10
}
while (uint32 r0 >= 100000000) {
    uint32 r0 -= 100000000
    uint32 r5 += 0x01
}
uint32 r5 <<= 24

// Generate 8 BCD digits using double dabble algorithm
int32 r1 = 0
for (int r2 = 0; r2 < 32; r2++) {           // loop for 32 bits
    int32 r3 = r1 + 0x33333333              // digit values 5-9 will set bit 3 in each 4-bit nibble
    int32 r3 &= 0x88888888                  // isolate bit 3 in each nibble
    int32 r4 = r3 >> 3                      // generate value 3 in nibbles with value 5-9
    int32 r3 >>= 2
    int32 r3 |= r4                          // this will have 3 for each nibble with a value 5-9
    int32 r1 += r3                          // add 3 to nibble values 5-9 to generate 8-12
    int32 r1 = funnel_shift(r0, r1, 31)     // shift most significant bit of r0 into r1
    int32 r0 <<= 1
}

// r5:r1 = BCD value

int r4 = 0                                  // remember if first digit has been printed

for (int r2 = 2; r2 > 0; r2--) {
    int32 r5 = rotate(r5, 4)                // get most significant digit first
    int8 r3 = r5 & 0x0F
    int r4 = (r3 != 0) || r4                // digit has been printed
    int8 r3 += '0'
    if (int r4 != 0) {
        int8 output(r3, r3, 10)             // print character to stdout
    }
}

// print 8 decimal digits
for (int r2 = 8; r2 > 0; r2--) {
    int32 r1 = rotate(r1, 4)                // get most significant digit first
    int8 r3 = r1 & 0x0F
    int r4 = (r3 != 0) || r4                // digit has been printed
    int r4 = (r2 == 1) || r4                // last digit must be printed
    int8 r3 += '0'
    if (int r4 != 0) {
        int8 output(r3, r3, 10)             // print character to stdout
    }
}

// restore r2-r5
int64 r2 = [sp]
int64 r3 = [sp+8]
int64 r4 = [sp+0x10]
int64 r5 = [sp+0x18]
int64 sp += 4*8
return
_print_integer end

code end