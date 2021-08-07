/*********************************  puts_light.as *****************************
* Author:        Agner Fog
* date created:  2021-05-16
* Last modified: 2021-05-16
* Version:       1.11
* Project:       ForwardCom library libc_light.li
* Description:   puts: print a string to stdout, append linefeed
* This version is for CPUs with limited capabilities
* C declaration: int puts (const char * str);
*
* Copyright 2021 GNU General Public License http://www.gnu.org/licenses
******************************************************************************/

code section execute align = 4                   // code section

// Print a string to stdout, append \n
_puts function public reguse=3,0
if (int64 r0 != 0) {  // check for null pointer
    while (true) {    // loop through string
        int8 r1 = [r0]             // read character
        if (int8 r1 == 0) {break}  // end of string
        int8 output(r1, r1, 10);   // output character
        int64 r0++                 // next character
    }
    int8 r1 = '\n'                 // write newline
    int8 output(r1, r1, 10);
    int r0 = 0                     // indicate success
    return 
}
int r0 = -1                        // indicate error
return
_puts end

code end