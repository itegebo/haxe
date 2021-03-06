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
import cs.system.text.regularExpressions.Regex;

@:coreApi class EReg {

	private var regex : Regex;
	private var m : Match;
	private var isGlobal : Bool;
	private var cur : String;

	public function new( r : String, opt : String ) : Void {
		var opts:Int = cast CultureInvariant;
		for (i in 0...opt.length) untyped {
			switch(cast(opt[i], Int))
			{
				case 'i'.code:
					opts |= cast(IgnoreCase, Int);
				case 'g'.code:
					isGlobal = true;
				case 'm'.code:
					opts |= cast(Multiline, Int);
				case 'c'.code:
					opts |= cast(Compiled, Int);
			}
		}

		this.regex = new Regex(r, cast(opts, RegexOptions));
	}

	public function match( s : String ) : Bool {
		m = regex.Match(s);
		cur = s;
		return m.Success;
	}

	public function matched( n : Int ) : String {
		if (m == null || cast(n, UInt) > m.Groups.Count)
			throw "EReg::matched";
		return m.Groups[n].Value;
	}

	public function matchedLeft() : String {
		return untyped cur.Substring(0, m.Index);
	}

	public function matchedRight() : String {
		return untyped cur.Substring(m.Index + m.Length);
	}

	public function matchedPos() : { pos : Int, len : Int } {
		return { pos : m.Index, len : m.Length };
	}

	public function split( s : String ) : Array<String> {
		if (isGlobal)
			return cs.Lib.array(regex.Split(s));
		var m = regex.Match(s);
		return untyped [s.Substring(0, m.Index), s.Substring(m.Index + m.Length)];
	}

	public function replace( s : String, by : String ) : String {
		if (isGlobal)
			return regex.Replace(s, by);
		var m = regex.Match(s);
		return untyped (s.Substring(0, m.Index) + by + s.Substring(m.Index + m.Length));
	}

	public function customReplace( s : String, f : EReg -> String ) : String {
		var buf = new StringBuf();
		while (true)
		{
			if (!match(s))
				break;
			buf.add(matchedLeft());
			buf.add(f(this));
			s = matchedRight();
		}
		buf.add(s);
		return buf.toString();
	}

}