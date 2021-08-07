/*********************************  print_characters_light.as **************
* Author:        Agner Fog
* date created:  2021-05-16
* Last modified: 2021-05-16
* Version:       1.11
* Project:       ForwardCom library libc_light.li
* Description:   puts: print a string to stdout. Does not append linefeed
* This version is for CPUs with limited capabilities
* C declaration: void print_characters.as(int64_t r0);
*
* Copyright 2021 GNU General Public License http://www.gnu.org/licenses
******************************************************************************/

code section execute                   // code section

// Prints multiple characters to stdout
// The characters to print are contained in integer s0
// Can be used with a 32-bit register or 64-bit register as parameter
// The parameter can hold a maximum of 4 characters if 32 bits, or 8 characters if 64 bits

_print_characters function public reguse=1,0
while (uint64 r0 != 0) {
    int8 output(r0, r0, 10);
    uint64 r0 >>= 8;
}
return
_print_characters end

code end