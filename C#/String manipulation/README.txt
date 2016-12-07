Add this class to your project and call its methods on a string.
Handles a lot of error checking that standard String methods dont.

Methods:
Mid - Returns a string of length X starting at position Y. If its longer than the string, just returns from position Y to the end.
MaxChars - Starts at the beginning and returns X characters. If the string is shorter than the length needed, returns the whole string
SurroundWith - surrounds a string with any character
FillLeft - left pads a string with specified character to X length
FillRight - right pads a string with specified character to X length
NullTrim - Trims a string, but if passed a null value will reurn null instead of erroring

Example use

Var str = "Hello World! This string is waaaay too long";
Var shrtStr = str.MaxChars(12).NullTrim(); // shrtStr now just "Hello World!"

