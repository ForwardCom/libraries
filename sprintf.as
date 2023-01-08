/*********************************  sprintf.as  *********************************
* Author:        Agner Fog
* date created:  2018-03-21
* Last modified: 2023-01-08
* Version:       1.12
* Project:       ForwardCom library libc.li
* Description:   printf function. Write a formatted data to console
* C declaration: int printf(const char *format, ...);
*
* Copyright 2018-2023 GNU General Public License v. 3
* http://www.gnu.org/licenses
*****************************************************************************/

// To do: make non-light versions of _sprintf and _snprintf

extern _sprintf_light:  function reguse=0xF,0    // write formatted string to string buffer
extern _snprintf_light: function reguse=0xF,0    // write formatted string to string buffer

code section execute align = 4

_sprintf function public reguse = 0xF, 0
jump _sprintf_light
_sprintf end

_snprintf function public reguse = 0xF, 0
jump _snprintf_light
_snprintf end

code end