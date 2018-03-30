/*********************************  raise_event *******************************
* Author:        Agner Fog
* date created:  2018-03-23
* Last modified: 2018-03-23
* Version:       1.00
* Project:       ForwardCom library libc.li
* Description:   raise_event: find event handlers and call them
* C declaration: int64_t raise_event(int64_t id_and_key, int64_t parameter1, const char * parameter2, ...)
*
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

extern __event_table: ip                         // address of event table
extern __event_table_num: constant               // size of event table
extern __ip_base: ip                             // reference point

code section execute align = 4

_raise_event function public
push (r16, r17, r18, r19, r20, r21, r22)         // save registers
int64 r16 = address([__event_table])             // address of event table
int32 r17 = __event_table_num                    // size of event table
int64 r18 = address([__ip_base])                 // reference point
int64 r19 = r0                                   // save ID and key
int64 r20 = r1                                   // save function parameters
int64 r21 = r2
int64 r22 = r3

// loop through event table
// (note: this table is sorted. we may use binary search if the table is big)
while (int64 r17 > 0) {
   int64 r0 = [r16+8]                            // read key and id from table entry
   if (int64 r0 == r19) {
      // matching record found
      int64 r1 = r20                             // function parameters are in r1, r2, r3
      int64 r2 = r21
      int64 r3 = r22
      int32 call(r18, [r16])                     // call relative function pointer from table, with r18 as reference point
      if (int64 r0 == 0) {break}                 // disable further events with same ID if return value is 0
   }
   int64 r16 += 16                               // next record in event table
   int64 r17--                                   // decrement loop counter
}
pop (r22, r21, r20, r19, r18, r17, r16)          // restore registers
return

_raise_event end

code end