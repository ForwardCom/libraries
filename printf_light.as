/****************************  printf_light.as ********************************
* Author:               Agner Fog
* date created:         2021-05-24
* Last modified:        2023-01-08
* ForwardCom version:   1.12
* Project:              ForwardCom library libc_light.li
* Description:
* printf_light, sprintf_light, snprintf_light: Print formatted output.
* These functions are light versions of printf, sprintf, and snprintf
* intended for embedded systems and small CPUs with limited capabilities.
* The following instructions are avoided: mul, div, push, pop, sys_call.
* Output to stdout goes directly to output port 10. It does not wait if
* the output buffer is full.
*
* C declarations:
* int printf_light   (const char * format, ... );
* int sprintf_light  (char * string, const char * format, ... );
* int snprintf_light (char * string, size_t max_length, const char * format, ... );
*
* printf_light:   print to stdout
* sprintf_light:  print to string
* snprintf_light: print to string with length limit
* fprintf_light:  print to file. not implemented yet
*
* These functions are following the definitions of printf etc. in the C standard.
* All standard features are supported, except the following:
* - cannot print floating point numbers
* - cannot print octal
* - cannot print decimal integers with more than 32 bits
*
* Copyright 2021-2023 GNU General Public License v. 3
* http://www.gnu.org/licenses
*****************************************************************************/

const section read ip

// call table for dispatching format string specifiers
call_table: int8  (specif_space-def)/4 // ' ': print space or minus
int8  0                                // !
int8  0                                // "
int8  (specif_hash-def)/4              // #: prepend 0x
int8  0                                // $
int8  (specif_percent-def)/4           // %: print percent sign
int8  0                                // &
int8  0                                // '
int8  0                                // (
int8  0                                // )
int8  (specif_star-def)/4              // *: width specified by parameter
int8  (specif_plus-def)/4              // +: print sign
int8  0                                // ,
int8  (specif_minus-def)/4             // -: left justified
int8  0                                // .
int8  0                                // /
int8  (specif_number-def)/4            // 0
int8  (specif_number-def)/4            // 1
int8  (specif_number-def)/4            // 2
int8  (specif_number-def)/4            // 3
int8  (specif_number-def)/4            // 4
int8  (specif_number-def)/4            // 5
int8  (specif_number-def)/4            // 6
int8  (specif_number-def)/4            // 7
int8  (specif_number-def)/4            // 8
int8  (specif_number-def)/4            // 9
int8  0                                // :
int8  0                                // ;
int8  0                                // <
int8  0                                // =
int8  0                                // >
int8  0                                // ?
int8  0                                // @
int8  (specif_hex-def)/4               // A: hexadecimal float
int8  0                                // B
int8  0                                // C
int8  0                                // D 
int8  (specif_float-def)/4             // E: float
int8  (specif_float-def)/4             // F: float
int8  (specif_float-def)/4             // G: float
int8  0                                // H
int8  0                                // I
int8  0                                // J
int8  0                                // K
int8  (specif_l-def)/4                 // L: long (long double)
int8  0                                // M
int8  0                                // N
int8  0                                // O
int8  0                                // P
int8  0                                // Q
int8  0                                // R
int8  0                                // S
int8  0                                // T
int8  0                                // U
int8  0                                // V
int8  0                                // W
int8  (specif_hex-def)/4               // X: hexadecimal
int8  0                                // Y
int8  0                                // Z
int8  0                                // [
int8  0                                // \
int8  0                                // ]
int8  0                                // ^
int8  0                                // _
int8  0                                // `
int8  (specif_hex-def)/4               // a: hexadecimal float
int8  0                                // b
int8  (specif_char-def)/4              // c: character
int8  (specif_dec-def)/4               // d: signed decimal
int8  (specif_float-def)/4             // e: float
int8  (specif_float-def)/4             // f: float
int8  (specif_float-def)/4             // g: float
int8  (specif_h-def)/4                 // h: short
int8  (specif_dec-def)/4               // i: signed decimal
int8  (specif_l-def)/4                 // j: intmax_t
int8  0                                // k
int8  (specif_l-def)/4                 // l: long
int8  0                                // m
int8  (specif_num-def)/4               // n: read number of characters printed so far
int8  0                                // o
int8  (specif_hex-def)/4               // p: pointer, print as hexadecimal
int8  0                                // q
int8  0                                // r
int8  (specif_string-def)/4            // s: string
int8  (specif_l-def)/4                 // t: ptrdiff_t
int8  (specif_uns-def)/4               // u: unsigned decimal
int8  0                                // v
int8  0                                // w
int8  (specif_hex-def)/4               // x: hexadecimal
int8  0                                // y
int8  (specif_l-def)/4                 // z: size_t
const end

code section execute align = 4         // code section


// _printf_light: print formatted string to stdout
// parameters: r0: format string, r1: parameter list
_printf_light function public reguse = 0xF, 0
  int64 r2 = r0                        // format string
  int64 r3 = r1                        // parameter list
  int64 sp -= 10*8                     // start saving registers
  int64 [sp+0x30] = r10                // save r10. The rest are saved under printf_generic
  int64 r10 = address ([char_to_stdout])
  jump printf_generic


// _sprintf_light: print formatted string to string buffer
// parameters: r0: destination string, r1: format string, r2: parameter list
_sprintf_light function public reguse = 0xF, 0
  int64 r3 = r2                        // parameter list
  int64 r2 = r1                        // format string
  int64 r1 = -1                        // character count limit = UINT_MAX
  int64 sp -= 10*8                     // start saving registers
  int64 [sp+0x30] = r10                // save r10. The rest are saved under printf_generic
  int64 r10 = address ([char_to_string])
  jump printf_generic


// _snprintf_light: print formatted string to string buffer with limit
// parameters: r0: destination string, r1: length limit, r2: format string, r3: parameter list
_snprintf_light function public reguse = 0xF, 0
  int64 r1--                           // character count limit. make space for terminating zero
  int64 sp -= 10*8                     // start saving registers
  int64 [sp+0x30] = r10                // save r10. The rest are saved under printf_generic
  int64 r10 = address ([char_to_string])
  // continue in printf_generic

printf_generic:                        // common procedure for all printf variants
  // save r4 - r13
  //int64 sp -= 10*8                   // this is done above
  int64 [sp+0x00] = r4
  int64 [sp+0x08] = r5
  int64 [sp+0x10] = r6
  int64 [sp+0x18] = r7
  int64 [sp+0x20] = r8
  int64 [sp+0x28] = r9
  // int64 [sp+0x30] = r10             // r10 saved above
  int64 [sp+0x38] = r11
  int64 [sp+0x40] = r12
  int64 [sp+0x48] = r13

  if (int64 r2 == 0) {jump finish}     // format string pointer is null
  int r13  = 0                         // reset field width
  int r11 = 0                          // reset modifiers
  int r12 = 0                          // state start
  
  // loop through format string
  while (true) {
    int8 r8 = [r2]                     // read character from format string
    if (int8+ r8 == 0) {break}         // end of format string
    int64 r2++                         // increment format string pointer

    if (int r12 == 0) {                // state start

      if (int8+ r8 == '%') {
        int r12 = 1                    // state after '%'
      }
      else {
        call (r10)                     // print character from format string
      }
      nop

    }
    else {                             // after '%' or modifier
      int r6 = r8 - ' '                // table index
      int64 r4 = address ([unknown_character])
      if (uint r6 > 91) {
        call (r4)                      // call unknown_character
      }
      else {
        int64 r5 = address ([call_table])
        int8 call_relative (r4, [r5 + r6*1])  // dispatch format specifier or modifier
      }
    }
  }
  finish:

  // if printing to string, insert terminating zero
  int64 r4 = address ([char_to_string])
  if (uint64 r10 >= r4) {
    int r4 = 0
    int8 [r0] = r4
  }
  int64 r0 = r9                        // return number of characters written

  // restore r4 - r13
  int64 r4  = [sp+0x00]
  int64 r5  = [sp+0x08]
  int64 r6  = [sp+0x10]
  int64 r7  = [sp+0x18]
  int64 r8  = [sp+0x20]
  int64 r9  = [sp+0x28]
  int64 r10 = [sp+0x30]
  int64 r11 = [sp+0x38]
  int64 r12 = [sp+0x40]
  int64 r13 = [sp+0x48]
  int64 sp += 10*8
  return                               // return from _printf_light, etc.


/////////////////////////////////////////////////////////////
// subfunctions for different characters in format string
/////////////////////////////////////////////////////////////

specif_space:                          // ' ': print space or minus
  if (int r12 != 1) {jump unknown_character}
  int r11 |= 8                         // set modifier flag
  return

specif_plus:                           // +: print sign
  if (int r12 != 1) {jump unknown_character}
  int r11 |= 4                         // set modifier flag
  return

specif_minus:                          // -: left justified
  if (int r12 != 1) {jump unknown_character}
  int r11 |= 1                         // set modifier flag
  return

specif_hash:                           // hash sign: print prefix 0x
  if (int r12 != 1) {jump unknown_character}
  int r11 |= 0x10                      // set modifier flag
  return

specif_h:                              // h: short
  int r4 = test_bits_or(r11, 0x40)     // is there a preceding h?
  int r11 |= 0x40                      // set modifier flag h
  int r11 |= 0x80, mask = r4           // set modifier flag hh
  int r12 = 3                          // state after sub_specifier
  return

specif_l:                              // l: long
  int r11 |= 0x20                      // set modifier flag l
  int r12 = 3                          // state after sub_specifier
  return

specif_percent:                        // %: print percent sign
  jump unknown_character               // just print % sign and reset state

specif_star:                           // *: width specified by parameter
  if (int r12 != 1) {jump unknown_character}
  int r13 = [r3]                       // read width from paramter
  int64 r3 += 8
  int r12 = 2                          // state after width
  int r11 |= 0x100                     // set modifier flag
  return

specif_number:                         // 0-9
  if (int r12 == 1) {
    if (int r8 == '0') {               // leading '0' means print leading zeroes
      int r11 |= 2                     // set modifier flag 2
      return
    }  
  }
  // number specifies width
  // width = previous_width * 10 + new_digit
  int r4 = r13 << 3                     // multiply width by 10
  int r13 <<= 1
  int r13 += r4
  int r8 -= '0'                        // convert from ASCII
  int r13 += r8                        // new width
  int r12 = 2                          // state after width
  int r11 |= 0x100                     // set modifier flag
  return

// subfunction for writing to stdout
char_to_stdout:
  int8 output(r8, r8, 10)              // write to stdout
  int64 r9++                           // count characters written
  return

// subfunction for writing to string
char_to_string:
  int64 r9++                           // count characters written or potentially written
  if (uint64 r9 > r1) {                // compare with string length limit
    jump char_to_string9               // stop printing
  }
  int8 [r0] = r8                       // write to string
  int64 r0++                           // increment string pointer
char_to_string9:
  return


// %n: read number of characters printed so far
specif_num:                            // n: read number of characters printed so far
  int64 r4 = [r3]                      // read pointer from parameter list
  int64 r3 += 8                        // increment parameter list
  int32 [r4] = r9                      // save number of characters written
  jump reset_state


// %c: Print character
specif_char:                           // c: print character
  int r13--                            // number of leading or trailing spaces to pring
  if (int !(r11 & 1)) {                // field is right justified. print leading spaces
    int r8 = ' '                       // leading spaces
    for (int; r13 > 0; r13--) {
      call (r10)                       // print space
    }
  }
  int8 r8 = [r3]                       // read character from parameter list
  int64 r3 += 8                        // increment parameter list
  call (r10)                           // print character
  int r8 = ' '                         // print any trailing spaces
  for (int; r13 > 0; r13--) {
    call (r10)                         // print space
  }
  jump reset_state


// %s: Print string
specif_string:                         // s: string
  int64 r6 = [r3]                      // read string pointer from parameter list
  int64 r3 += 8                        // increment parameter list
  if (int64 r6 == 0) {jump unknown_character} // null string
  int r4 = r11 ^ 1                     // check if right justified
  int16+ test_bits_and(r4, 0x101), jump_false specif_string2 
  // string is right justified with specified width. check if leading spaces are needed
  for (int r5 = 0; r5 < r13; r5++) {
    int8 r8 = [r6+r5]                  // read string character
    if (int8+ r8 == 0) {break}         // string is shorter. leading spaces needed
  }
  // print leading spaces
  int r8 = ' '
  for (int ; r5 < r13; r5++) {
    call (r10)                         // print space
  }
  int r13 = 0                           // avoid printing trailing spaces also
  specif_string2:
  while (true) {
    int8 r8 = [r6]                     // read character from string
    if (int8+ r8 == 0) {break}         // end of string
    int64 r6++                         // increment string pointer
    call (r10)                         // print character
    int r13--                           // count down field width
  }
  // print any trailing space
  int r8 = ' '
  while (int r13 > 0) {
    call (r10)                         // print character
    int r13--                           // count down field width
  }
  jump reset_state


// %e, %f, %g: Print floating point number
specif_float:
    //jump specif_float1               // (intermediate jump target specif_float placed here to avoid overflow in call table)

    // float not implemented. print as %#LX
    int r11 |= 0x30                    // print 0x prefix, 64 bits
    jump specif_hex


// reference point, default in call table, print unknown character:
def:                                   // default, reference point in call table
unknown_character:                     // unknown character after '%'
  call r10                             // print character
  //jump reset_state
reset_state:                           // reset state after '%' command
  int r11 = 0                          // reset modifiers
  int r12 = 0                          // state start
  int r13 = 0                          // reset field width
  return


// %x: Print hexadecimal
specif_hex:                            // X: hexadecimal
  int r7 = r8 & 0x20                   // is lower case
  int64 r4 = [r3]                      // read integer from parameter list
  int64 r3 += 8                        // increment parameter list
  if (int !(r11 & 0x20)) {             // check if long int
    int32 r4 = r4                      // not long. truncate to 32 bits
  }
specif_hex2:                           // entry from %i (decimal) if number too big
  int64 r5 = bitscan(r4, 1)            // find number of bits
  uint32 r5 >>= 2
  int32 r5++                           // number of digits to print
  int r13 -= r5                        // number of leading or trailing spaces to print
  int r6 = test_bit(r11, 4)            // '#' option
  int r13 -= 2, mask = r6              // make space of 0x prefix

  if (int !(r11 & 1)) {                // field is right justified. print leading spaces
    int r8 = ' '                       // leading spaces
    int r6 = test_bit(r11, 1)          // get bit 1: leading zeroes
    int r8 = '0', mask=r6, fallback=r8 // leading zeroes instead of leading spaces
    while (int r13 > 0) {              // print r13 leading spaces or zeroes
      call r10
      int r13--
    }  
  }

  if (int r11 & 0x10) {                // '#' flag. Print 0x prefix
    int r8 = '0'
    call r10
    int r8 = 'X' | r7                  // 'x' or 'X'
    call r10
  }

  // convert to hexadecimal
  if (int r5 > 8) {                    // must use 64 bits
      int r6 = 16 - r5                 // number of digits to skip
      int r6 <<= 2                     // number of bits to skip
      uint64 r4 <<= r6                 // remove leading zero bits
      for (int ; r5 > 0; r5--) {       // loop for r5 digits
          uint64 r4 = rotate(r4, 4)    // get digit into low position
          int r8 = r4 & 0xF            // get digit
          int r8 += '0'                // convert to ASCII
          int r6 = r8 > '9'            // digit is A - F
          int r8 += 7, mask = r6       // add 7 to get letter A - F
          int r8 |= r7                 // lower case
          call r10                     // print character
      }
  }
  else {   // use 32 bits. CPU may not support 64 bits
      int r6 = 8 - r5                  // number of digits to skip
      int r6 <<= 2                     // number of bits to skip
      uint32 r4 <<= r6                 // remove leading zero bits
      for (int ; r5 > 0; r5--) {       // loop for r5 digits
          uint32 r4 = rotate(r4, 4)    // get digit into low position
          int r8 = r4 & 0xF            // get digit
          int r8 += '0'                // convert to ASCII
          int r6 = r8 > '9'            // digit is A - F
          int r8 += 7,  mask = r6      // add 7 to get letter A - F
          int r8 |= r7                 // lower case
          call r10                     // print character
      }
  }
  // print any trailing spaces
  int r8 = ' '                         // trailing spaces
  while (int r13 > 0) {                // print r13 trailing spaces
    call r10
    int r13--
  }  
  jump reset_state


// %i, %d: Print signed decimal integer
specif_dec:                            // i: signed decimal
  int64 r4 = [r3]                      // read integer from parameter list
  int64 r3 += 8                        // increment parameter list
  if (int r11 & 0x20) {                // %li: 64-bit integer
    int64 r5 = test_bit(r4, 63)        // get sign bit
    int64 r4 = -r4, mask = r5          // change sign if negative
    int r11 |= 0x200, mask = r5        // set bit to remember negative
    int64 r6 = bitscan(r4, 1)          // find number of bits
    if (int r6 > 31) {                 // cannot handle 64 bits decimal. Do hexadecimal instead
      int r11 |= 0x11                  // prepare for hexadecimal escape. get 0x prefix and left justify
      int r7 = 0                       // use upper case for hexadecimal escape
      if (int8+ r5 & 1) {
        int r8 = '-'                   // print '-'
        call r10
      }
      jump specif_hex2                 // print as hexadecimal
    }
  }
  else {
    if (int r11 & 0x80) {              // %hhi: int8
      int32 r5 = test_bit(r4, 7)       // get sign bit
      int8 r4 = -r4, mask = r5         // change sign if negative. truncate to 8 bits
      int r11 |= 0x200, mask = r5      // set bit to remember negative
    }
    else {
      if (int r11 & 0x40) {            // %hhi: int16
        int32 r5 = test_bit(r4, 15)    // get sign bit
        int16 r4 = -r4, mask = r5      // change sign if negative. truncate to 16 bits
        int r11 |= 0x200, mask = r5    // set bit to remember negative      
      }
      else {
        // %i: int32
        int32 r5 = test_bit(r4, 31)    // get sign bit
        int32 r4 = -r4, mask = r5      // change sign if negative. truncate to 16 bits
        int r11 |= 0x200, mask = r5    // set bit to remember negative
      }
    }
  }
  jump specif_uns2                     // sign has been stored in r11. continue in unsigned


// %u: Print unsigned decimal integer
specif_uns:                           // u: unsigned decimal
  int64 r4 = [r3]                      // read integer from parameter list
  int64 r3 += 8                        // increment parameter list
  if (int r11 & 0x20) {                // %li: 64-bit integer
    int64 r6 = bitscan(r4, 1)          // find number of bits
    int r8 |= 0x10                     // prepare for hexadecimal escape. get 0x prefix
    int r7 = 0                         // use upper case for hexadecimal escape
    if (int r6 > 31) {jump specif_hex2}// cannot handle 64 bits decimal. Do hexadecimal instead
  }

specif_uns2:
  int64 sp -= 8                        // save r14
  int64 [sp] = r14

  // 32 bit decimal signed or unsigned
  // First two BCD digits are made with simple subtraction to avoid the need for a larger bit field
  int r5 = 0                           // upper two BCD digits

  while (uint32 r4 >= 1000000000) {
    uint32 r4 -= 1000000000
    uint32 r5 += 0x10
  }
  while (uint32 r4 >= 100000000) {
    uint32 r4 -= 100000000
    uint32 r5 += 0x01
  }
 
  // Generate 8 BCD digits using double dabble algorithm
  int32 r14 = 0                        // generate BCD in r14 
  for (int r6 = 0; r6 < 32; r6++) {    // loop for 32 bits
      int32 r7 = r14 + 0x33333333      // digit values 5-9 will set bit 3 in each 4-bit nibble
      int32 r7 &= 0x88888888           // isolate bit 3 in each nibble
      int32 r8 = r7 >> 3               // generate value 3 in nibbles with value 5-9
      int32 r7 >>= 2
      int32 r7 |= r8                   // this will have 3 for each nibble with a value 5-9
      int32 r14 += r7                  // add 3 to nibble values 5-9 to generate 8-12
      int32 r14 = funnel_shift(r4, r14, 31)  // shift most significant bit of r4 into r14
      int32 r4 <<= 1
  }
  // r5:r14 = BCD value

  // determine width
  int r6 = bitscan(r14, 1)             // number of significant bits
  uint r6 >>= 2                        // number of significant digits in low part
  int r6++                             // number of digits in low part
  if (int r5 != 0) {                   // high part is nonzero
    int r6 = bitscan(r5, 1)            // find number of digits in high part
    uint r6 >>= 2
    int r6 += 9                        // number of digits total
  }
  int r7 = test_bits_or(r11, 0x20C)    // leading sign needed
  int r6 += r7                         // number of characters needed
  int r13 -= r6                        // number of leading or trailing spaces needed

  if (int !(r11 & 1)) {                // right justified
    int r6 = r13 > 0 && r7             // leading sign && leading spaces
    int r4 = test_bit(r11, 1), options=1, fallback=r6 // leading zeroes and leading sign. sign must come first
    int r8 = ' '                       // leading sign to print
    int r6 = test_bit(r11, 2)          // flag for '+' prefix
    int r8 = '+', mask=r6, fallback=r8 // leading + required if not negative
    int r6 = test_bit(r11, 9)          // flag for negative
    int r8 = '-', mask=r6, fallback=r8 // leading -. value is negative
    if (int r4 & 1) {                  // sign must come before leading zeroes
      call r10                         // print leading sign
      int r7 = 0                       // remember leading sign has been written
    }
    // print leading spaces or zeroes
    int r8 = ' '                       // space
    int r6 = test_bit(r11, 1)          // flag for leading zeroes
    int r8 = '0', mask=r6, fallback=r8
    while (int r13 > 0) {              // write leading spaces or zeroes
      call r10
      int r13--
    }
  }
  if (int r7 & 1) {                    // sign after leading spaces
    int r8 = ' '                       // space
    int r6 = test_bit(r11, 2)          // flag for '+' prefix
    int r8 = '+', mask=r6, fallback=r8 // leading + required if not negative
    int r6 = test_bit(r11, 9)          // flag for negative
    int r8 = '-', mask=r6, fallback=r8 // leading -. value is negative
    call r10                           // write sign
  }

  int r4 = 0                           // remember if first digit has been printed

  // print high two digits
  uint32 r5 <<= 24                     // left justify high part
  for (int r6 = 2; r6 > 0; r6--) {     // print two high digits if any
      int32 r5 = rotate(r5, 4)         // get most significant digit first
      int8 r8 = r5 & 0x0F
      int r4 = (r8 != 0) || r4         // digit has been printed
      int8 r8 += '0'                   // convert to ASCII
      if (int r4 != 0) {
          call r10                     // print character to stdout
      }
  }

  // print low 8 decimal digits
  for (int r6 = 8; r6 > 0; r6--) {
      int32 r14 = rotate(r14, 4)       // get most significant digit first
      int8 r8 = r14 & 0x0F
      int r4 = (r8 != 0) || r4         // digit has been printed
      int r4 = (r6 == 1) || r4         // last digit must be printed
      int8 r8 += '0'                   // convert to ASCII
      if (int r4 != 0) {
          call r10                     // print character to stdout
      }
  }

  // print trailing spaces
  int r8 = ' '                         // space
  while (int r13 > 0) {                // write trailing spaces
    call r10
    int r13--
  }

  int64 r14 = [sp]                     // restore r14
  int64 sp += 8                        

  jump reset_state                     // finished


  // %e, %f, %g: Print floating point number. not implemented
specif_float1:
  nop
  jump reset_state                     // finished

code end