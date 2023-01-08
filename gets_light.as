/****************************  gets_light.as **********************************
* Author:        Agner Fog
* date created:  2021-05-25
* Last modified: 2023-01-08
* Version:       1.12
* Project:       ForwardCom library libc_light.li
* Description:   gets_s: Read a string from standard input until newline
* This version is for small CPUs with limited capabilities
* The following instructions are avoided: mul, div, push, pop, sys_call.
* Input comes directly from input port 8
* Output to stdout goes directly to output port 10
*
* C declaration:
* char *gets_s (char *string, size_t max_length);
*
* This function is defined in the C11 standard
* It will read a string from stdin until a newline or carriage return is 
* encountered or the maximum length is reached.
* The input is echoed to standard output.
* The newline or carriage return is not included in the string. 
* A terminating zero is always inserted at the end of the string.
* If the string length, including the terminating zero, exceeds max_length
* then the superfluous characters are discarded and it keeps reading until
* a newline or carriage return. 
* This version does not raise any exception in case max_length is exceeded,
* but returns a truncated string. 
* A NULL pointer is returned if any of the input parameters are zero.
* The C standard says that reading ends at newline, but Windows versions end
* at carriage return. This version supports both for the sake of compatibility.
*
* Copyright 2021-2023 GNU General Public License v. 3
* http://www.gnu.org/licenses
*****************************************************************************/

// define input and output port numbers
%stdin_port = 8
%stdin_status_port = 9
%stdout_port = 10


code section execute 

_gets_s function public reguse = 3, 0

  // save r2, r3
  int64 sp -= 2*8
  int64 [sp] = r2
  int64 [sp+8] = r3

  // check if parameters are valid
  if (int64 r0 == 0) {jump gets_s_error}         // error: null pointer or zero length
  if (int64 r1 == 0) {jump gets_s_error}         // error: zero length

  int64 r2 = r0                                  // point to current position in output buffer

  // loop until newline or maximum string length
  while (true) {

    // wait for input
    do {
      int16 r3 = input(r3, stdin_status_port)    // check if there is input
    }
    while (int r3 == 0);

    int8 r3 = input(r3, stdin_port)              // read one byte from input    
    int8 output(r3, r3, stdout_port)             // echo input
    if (int r3 == 10) {break}                    // stop at newline
    if (int r3 == 13) {break}                    // optionally stop at charriage return if keyboard input
    int64 r1--                                   // count down maximum length
    if (int64 r1 <= 0) {continue}                // length limit reached. keep reading until newline
    int8 [r2] = r3                               // store byte as character in output buffer
    int64 r2++                                   // increment string pointer
  }
  int  r3 = 0                                    // insert terminating zero
  int8 [r2] = r3
  gets_s_9:

  // restore r2, r3
  int64 r2 = [sp]
  int64 r3 = [sp+8]
  int64 sp += 2*8
  return

  gets_s_error:
  int r0 = 0
  jump gets_s_9

code end