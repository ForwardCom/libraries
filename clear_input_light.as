/****************************  clear_input_light.as ***************************
* Author:        Agner Fog
* date created:  2021-05-31
* Last modified: 2021-05-31
* Version:       1.11
* Project:       ForwardCom library libc_light.li
* Description:   clear_input: Clear input buffer for stdin
* This version is for small CPUs with limited capabilities
* The following instructions are avoided: mul, div, push, pop, sys_call.
* Input comes directly from input port 8
* Output to stdout goes directly to output port 10
*
* C declaration:
* void clear_input();
*
* Copyright 2021 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

// define input and output port numbers
%stdin_port = 8
%stdin_status_port = 9
%stdout_port = 10


code section execute 

_clear_input function public reguse = 0, 0
  // save r1
  int64 sp -= 1*8
  int64 [sp] = r1

  int r1 = 1
  int output(r1,r1,stdin_status_port)  // clear input buffer

  // restore r1
  int64 r1 = [sp]
  int64 sp += 1*8
  return

_clear_input end

code end