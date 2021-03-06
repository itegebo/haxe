/*
 * Copyright (C)2005-2012 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
package js;

import js.Dom;

class Lib {

	public static var document : Document;
	public static var window : Window;
	static var onerror : String -> Array<String> -> Bool = null;

	/**
		Inserts a 'debugger' statement that will make a breakpoint if a debugger is available.
	**/
	public static inline function debug() {
		untyped __js__("debugger");
	}

	/**
		Display an alert message box containing the given message
	**/
	public static function alert( v : Dynamic ) {
		untyped __js__("alert")(js.Boot.__string_rec(v,""));
	}

	public static inline function eval( code : String ) : Dynamic {
		return untyped __js__("eval")(code);
	}

	public static inline function setErrorHandler( f ) {
		onerror = f;
	}

	static function __init__() {
		if( untyped __js__("typeof document") != "undefined" )
			document = untyped __js__("document");
		if( untyped __js__("typeof window") != "undefined" ) {
			window = untyped __js__("window");
			window.onerror = function( msg, url, line ) {
				var f = Lib.onerror;
				if( f == null )
					return false;
				return f(msg, [url+":"+line]);
			};
		}
	}

}
