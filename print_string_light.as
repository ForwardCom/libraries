/*********************************  print_string_light.as *****************************
* Author:        Agner Fog
* date created:  2021-05-16
* Last modified: 2021-05-16
* Version:       1.11
* Project:       ForwardCom library libc_light.li
* Description:   puts: print a string to stdout. Does not append linefeed
* This version is for CPUs with limited capabilities
* C declaration: const char * print_string (const char * str);
*
* Copyright 2021 GNU General Public License http://www.gnu.org/licenses
******************************************************************************/

code section execute align = 4                   // code section

// Prints a string to stdout. Same as _puts, but does not append newline
// Returns a pointer to the first character after the string

_print_string function public reguse=3,0
if (int64 r0 != 0) {  // check for null pointer
    while (true) {    // loop through string
        int8 r1 = [r0]             // read character
        int64 r0++                 // next character
        if (int8 r1 == 0) {break}  // end of string
        int8 output(r1, r1, 10);   // output character
    }
}
return 
_print_string end


code end