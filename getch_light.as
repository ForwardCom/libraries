/*********************************  getch_light.as ****************************
* Author:        Agner Fog
* date created:  2021-05-25
* Last modified: 2021-05-25
* Version:       1.11
* Project:       ForwardCom library libc_light.li
* Description:   Common C functions: _kbhit, getch, getche
*                Nonstandard function: getch_nonblocking
*
* This version is for small CPUs with limited capabilities
* The following instructions are avoided: mul, div, push, pop, sys_call.
* Input comes directly from input port 8
* Output to stdout goes directly to output port 10
*
* The functions _kbhit, getch, getche are common, but not part of the official C standard.
* getch_nonblocking is my own invention. It is sadly missing in common systems
*
* C declarations:
* int _kbhit(void);
* int getch(void);
* int getche(void);
* int getch_nonblocking(void);
*
* Description:
* _kbhit:   return 1 if there is at least one character in the input buffer, 0 if buffer empty
* getch:    waits for input from stdin. returns one character
* getche:   same as getch. The input is echoed to the standard output
* getch_nonblocking: reads one character from stdin without waiting. returns -1 if the input buffer is empty
*
* Copyright 2021 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

// define input and output ports
%stdin_port = 8
%stdin_status_port = 9
%stdout_port = 10


code section execute 

// _kbhit function
// returns 0 if there is no input
// returns 1 if the standard input input buffer contains at least one character
_kbhit function public reguse = 1,0
__kbhit function public reguse = 1,0

  int r0 = input(r0, stdin_status_port)// read status port
  int16 r0 = r0 != 0                   // bit 0-15 = number of bytes in input buffer
  return


// _getch function
// waits for input from standard input. returns one character in the interval 0 - 0xFF
// no error checking
_getch function public reguse = 1,0

  do {                                 // keep reading until input data valid
    int r0 = input(r0, stdin_port)     // read from input port
  }
  while (int !(r0 & 0x100));           // bit 8 = data valid
  int8 r0 = r0                         // isolate bit 0-7
  return


// _getche function
// same as _getch
// echoes character to standard output
_getche function public reguse = 1,0

  do {                                 // keep reading until input data valid
    int r0 = input(r0, stdin_port)     // read from input port
  }
  while (int !(r0 & 0x100));           // bit 8 = data valid
  int8 r0 = r0                         // isolate bit 0-7
  int output(r0, r0, stdout_port)      // output the same character
  return


// _getch_nonblocking function
// reads input from standard input. Does not wait for input
// returns one character in the interval 0 - 0xFF if input available
// returns -1 if input buffer empty
// future implementations may return other negative values in case of error
_getch_nonblocking function public reguse = 1,0

  int r0 = input(r0, stdin_port)       // read from input port
  if (int (r0 & 0x100)) {              // bit 8 = data valid
    int8 r0 = r0                       // isolate bit 0-7
    return
  }
  int r0 = -1                          // input buffer empty. return -1
  return

code end