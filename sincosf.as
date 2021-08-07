/*********************************  sincosf.as  *******************************
* Author:        Agner Fog
* date created:  2020-04-29
* Last modified: 2021-04-25
* Version:       1.11
* Project:       ForwardCom library math.li
* Description:   sin, cos, and tan functions. Calculate in radians, single precision
*                The argument x can be a scalar or a vector
*                The return value will be a vector with the same length
* C declaration: float sin(float x);
* C declaration: float cos(float x);
* C declaration: float tan(float x);
* C declaration: struct {float s; float c;} sincos(float x);
*
* This code is adapted from C++ vector class library www.github.com/vectorclass
* Copyright 2020-2021 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/


// define constants
% M_2_PI = 0.636619772367581343076       // 2./pi

% P0sinf = -1.6666654611E-1
% P1sinf = 8.3321608736E-3
% P2sinf = -1.9515295891E-4
% P0cosf = 4.166664568298827E-2
% P1cosf = -1.388731625493765E-3
% P2cosf = 2.443315711809948E-5

% DP1F = 0.78515625 * 2.
% DP2F = 2.4187564849853515625E-4 * 2.
% DP3F = 3.77489497744594108E-8 * 2.


code section execute align = 4

public _sinf:    function, reguse = 0, 0x1BF
public _cosf:    function, reguse = 0, 0x1BF
public _sincosf: function, reguse = 0, 0x1BF
public _tanf:    function, reguse = 0, 0x1BF

// common entry for sin and sincos functions
_sinf function
_sincosf: 

/* registers:
  v0 = x
  v1 = abs(x)
  v1 = quadrant
  v2 = x^2
  v3 = x^3
  v4 = x^4
  v5 = temp
  v5 = sin
  v6 = unused (vacant flag for calling function)
  v7 = cos
  v8 = abs(x) reduced modulo pi/2
*/

// Find quadrant:
//      0 -   pi/4 => 0
//   pi/4 - 3*pi/4 => 1
// 3*pi/4 - 5*pi/4 => 2
// 5*pi/4 - 7*pi/4 => 3
// 7*pi/4 - 8*pi/4 => 4

// reduce modulo pi/2, with extended precision
//nop
float v1 = clear_bit(v0, 31)                    // abs(x)
float v5 = v1 * M_2_PI
float v5 = round(v5, 0)   // round to integer

// x = ((xa - y * DP1) - y * DP2) - y * DP3;
float v8 = v5 * (-DP1F) + v1 
float v8 = v5 * (-DP2F) + v8
float v8 = v5 * (-DP3F) + v8

float v3 = !(v5 > ((1 << 22) + 0.0))            // check for loss of precision and overflow, but not NAN
float v1 = v5 + ((1 << 23) + 0.0)               // add magic number 2^23 to get integer into lowest bit
float v8 = v3 ? v8 : 0                          // zero if out of range. result will be -1, 0, or 1

// Taylor expansion of sin and cos, valid for -pi/4 <= x <= pi/4
// s = polynomial_2(x^2, P0sinf, P1sinf, P2sinf) * (x*x^2) + x;

float v2 = v8 * v8        // x^2
float v3 = v8 * v2        // x^3
float v4 = v2 * v2        // x^4
float v5 = replace(v8, P0sinf)                   // broadcast to same length as x
float v5 = v2 * P1sinf + v5
float v5 = v4 * P2sinf + v5
float v5 = v5 * v3 + v8                          // sin

// c = polynomial_2(x2, P0cosf, P1cosf, P2cosf) * (x2*x2) + nmul_add(0.5f, x2, 1.0f);
float v7 = replace(v8, P0cosf)                   // broadcast to same length as x
float v7 = v2 * P1cosf + v7
float v7 = v4 * P2cosf + v7
float v3 = replace(v8, 1.0)
float v3 = v2 * (-0.5) + v3                       // 1 - 0.5*x^2
float v7 = v7 * v4 + v3                           // cos

// swap sin and cos if odd quadrant
float v3 = v1 ? v7 : v5        // sin
float v4 = v1 ? v5 : v7        // cos

// get sign of sin
int32  v5 = v1 << 30            // get bit 1 into sign bit, x modulo pi/2 = 2 or 3
int32  v5 ^= v0                 // toggle with sign of original x
int32  v5 = and(v5, 1 << 31)    // isolate sign bit
float  v0 = v3 ^ v5             // apply sign bit to sin

// get sign of cos
int32  v1 = v1 + 1              // change sign when x modulo pi/2 = 1 or 2
int32  v1 = v1 << 30            // get bit 1 into sign bit
int32  v1 = and(v1, 1 << 31)    // isolate sign bit
float  v1 = v4 ^ v1             // apply sign bit to cos

// return sin in v0, cos in v1
return
_sinf end

// cosine function
_cosf function
call _sincosf
float v0 = v1                                   // cos is in v1
return
_cosf end

// tangent function
_tanf function
call _sincosf
float v0 = v0 / v1                              // tan(x) = sin(x)/cos(x)
return
_tanf end

code end