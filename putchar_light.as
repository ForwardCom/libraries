/*********************************  putchar_light.as **************************
* Author:        Agner Fog
* date created:  2021-05-16
* Last modified: 2021-05-16
* Version:       1.11
* Project:       ForwardCom library libc_light.li
* Description:   putchar: print a character to stdout
* This version is for CPUs with limited capabilities
* C declaration: int putchar(int character)
*
* Copyright 2021 GNU General Public License http://www.gnu.org/licenses
******************************************************************************/

code section execute align = 4                   // code section

// Print a single character to stdout
_putchar function public reguse = 1, 0
int8 output(r0, r0, 10);
return 
_putchar end

code end