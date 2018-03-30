/*********************************  sin.as  ***********************************
* Author:        Agner Fog
* date created:  2018-03-29
* Last modified: 2018-03-29
* Version:       1.00
* Project:       ForwardCom library math.li
* Description:   sin, cos, and tan functions. Calculate in radians, double precision
*                The argument x can be a scalar or a vector
*                The return value will be a vector with the same length
* C declaration: double sin(double x);
* C declaration: double cos(double x);
* C declaration: double tan(double x);
* C declaration: struct {double s; double c;} sincos(double x);
*
* This code is adapted from C++ vector class library www.github.com/vectorclass
* Copyright 2018 GNU General Public License http://www.gnu.org/licenses
*****************************************************************************/

// define constants
% M_2_PI = 0.636619772367581343076       // 2./pi
% P0sin  = -1.66666666666666307295E-1    // polynomial coefficients for sin
% P1sin  = 8.33333333332211858878E-3
% P2sin  = -1.98412698295895385996E-4
% P3sin  = 2.75573136213857245213E-6
% P4sin  = -2.50507477628578072866E-8
% P5sin  = 1.58962301576546568060E-10

% P0cos  = 4.16666666666665929218E-2     // polynomial coefficients for cos
% P1cos  = -1.38888888888730564116E-3
% P2cos  = 2.48015872888517045348E-5
% P3cos  = -2.75573141792967388112E-7
% P4cos  = 2.08757008419747316778E-9
% P5cos  = -1.13585365213876817300E-11

% DP1    = 7.853981554508209228515625E-1 // modulo pi/2 for extended precision
% DP2    = 7.94662735614792836714E-9     // correction for extended precision modular artithmetic
% DP3    = 3.06161699786838294307E-17    // correction for extended precision modular artithmetic


code section execute align = 4

public _sin:    function, reguse = 0, 0x3FF
public _cos:    function, reguse = 0, 0x3FF
public _sincos: function, reguse = 0, 0x3FF
public _tan:    function, reguse = 0, 0x3FF

// common entry for sin and sincos functions
_sin function
_sincos: 

/* registers:
  v0 = x
  v1 = abs(x)
  v1 = quadrant
  v2 = abs(x) reduced modulo pi/2
  v3 = v2^2
  v4 = v2^4
  v5 = v2^8
  v6 = v2^3
  v8 = sin
  v9 = cos
*/

// Find quadrant:
//      0 -   pi/4 => 0
//   pi/4 - 3*pi/4 => 1
// 3*pi/4 - 5*pi/4 => 2
// 5*pi/4 - 7*pi/4 => 3
// 7*pi/4 - 8*pi/4 => 4

double v1 = clear_bit(v0, 63)                    // abs(x)
double v5 = v1 * M_2_PI
double v5 = round(v5, 0)   // round to integer
// reduce modulo pi/2, with extended precision
// x = ((xa - y * DP1) - y * DP2) - y * DP3;
double v2 = v1 + v5 * (-DP1*2)
double v2 = v2 + v5 * (-DP2*2)
double v2 = v2 + v5 * (-DP3*2)
double v6 = clear_bit(v5, 63)                    // abs
double v6 = v6 < ((1 << 51) + 0.0)               // check for loss of precision and overflow
double v1 = v5 + ((1 << 52) + 0.0)               // add magic number 2^52 to get integer into lowest bit
double v2 = v6 ? v2 : 0                          // zero if out of range. result will be -1, 0, or 1

// Expansion of sin and cos, valid for -pi/4 <= x <= pi/4
double v3 = v2 * v2                              // x^2
double v4 = v3 * v3                              // x^4
double v5 = v4 * v4                              // x^8

// calculate polynomial P5sin*x2^5 + P4sin*x2^4 + P3sin*x2^3 + P2sin*x2^2 + P1sin*x2 + P0sin
// = (p2+p3*x2)*x4 + ((p4+p5*x2)*x8 + (p0+p1*x2));

double v6 = replace(v2, P0sin)                   // broadcast to same length as x
double v6 = v6 + v3 * P1sin
double v7 = replace(v2, P4sin)
double v7 = v7 + v3 * P5sin
double v8 = replace(v2, P2sin)
double v8 = v8 + v3 * P3sin
double v7 = v7 * v5 + v6
double v8 = v8 * v4 + v7

// calculate polynomial P5cos*x2^5 + P4cos*x2^4 + P3cos*x2^3 + P2cos*x2^2 + P1cos*x2 + P0cos
// = (p2+p3*x2)*x4 + ((p4+p5*x2)*x8 + (p0+p1*x2));
double v6 = replace(v2, P0cos)
double v6 = v6 + v3 * P1cos
double v7 = replace(v2, P4cos)
double v7 = v7 + v3 * P5cos
double v9 = replace(v2, P2cos)
double v9 = v9 + v3 * P3cos
double v7 = v7 * v5 + v6
double v9 = v9 * v4 + v7

// s = x + (x * x2) * s;
double v6 = v2 * v3
double v8 = v8 * v6 + v2
// c = 1.0 - x2 * 0.5 + (x2 * x2) * c;
double v9 = v9 * v4
double v9 = v9 + v3 * (-0.5)
double v9 = 1.0 + v9

// swap sin and cos if odd quadrant
double v4 = v1 ? v9 : v8        // sin
double v5 = v1 ? v8 : v9        // cos

// get sign of sin
int64  v6 = v1 << 62            // get bit 1 into sign bit, x modulo pi/2 = 2 or 3
int64  v6 ^= v0                 // toggle with sign of original x
int64  v6 = and_bit(v6, 63)     // isolate sign bit
double v0 = v4 ^ v6             // apply sign bit to sin

// get sign of cos
int64  v1 = v1 + 1              // change sign when x modulo pi/2 = 1 or 2
int64  v1 = v1 << 62            // get bit 1 into sign bit
int64  v1 = and_bit(v1, 63)     // isolate sign bit
double v1 = v5 ^ v1             // apply sign bit to cos

// return sin in v0, cos in v1
return
_sin end

// cosine function
_cos function
call _sincos
double v0 = v1                                   // cos is in v1
return
_cos end

// tangent function
_tan function
call _sincos
double v0 = v0 / v1                              // tan(x) = sin(x)/cos(x)
return
_tan end

code end