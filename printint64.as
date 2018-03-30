/*********************************  printint32.as *****************************
* Author:        Agner Fog
* date created:  2018-03-23
* Last modified: 2018-03-23
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   printint32: print integer to stdout
* C declaration: void printint64 (int64_t x)
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

data section datap align = 8
parlist: int64 0                       // parameter list
format:  int8 "%lli",0                 // format string
data end

extern _printf: function

code section execute align = 4         // code section

_printint64 function public
int64 [parlist] = r0                   // save x in parameter list
int64 r0 = address([format])           // first parameter is format string
int64 r1 = address([parlist])          // parameter list
jump _printf                           // tail call to _printf
_printint64 end

code end