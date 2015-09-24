# SwiftUtilities

A smorgasbord of Swift source code.

## Highlights

* A CCITT X.25 CRC16 implementation (very popular at parties)
* A generic tree walker
* A NSScanner-like DataScanner class. Useful for parsing binary data.
* Base conversions between strings, integers and data (e.g. UnsafeBufferPointer). Hex, octal, binary and other bases supported (also includes support for Swift style constants e.g. convert "0xDEAD_BEEF" into an integer)
* BitRange - get set bits or ranges of bits inside binary data
* BufferType protocol - an attempt to unify NSData, UnsafeBufferPointers and DispatchData.
* DispatchData - a lovely Swift wrapper around GCD's dispatch_data_t.
* Path - yet another Path implementation. Loosely based on Python's pathlib
* Random number generators (including a wrapper around C++'s mt19937_64 Mersenne Twister) with some useful random functions such as range ranges and shuffles.
* RegularExpression
* Swift String/NSString range conversions
* unsafeBitwiseEquality - A generic wrapper around memcmp - good for quick implementations of func == for simple structs.
* Useful math stuff: Degree/Radian conversions, a ** operator

## Status

This project is used in a lot of my Swift work (including 3D Robotics iSolo project). Interfaces do change rapidly and backwards compatibility is not guaranteed. To insulate yourself from this change you are welcome to pul out the individual files and classes you need - just so long as you maintain the license.

The Xcode project produces iOS and Mac dynamic frameworks. This project is compatible with Carthage.

## License

BSD 2 Clause.
