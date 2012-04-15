package haxe.lang;private typedef NativeString = String;/** * ... * @author waneck */@:keep @:nativegen @:native("haxe.lang.StringExt") private class StringExt{	@:functionBody('			if ( ((uint) index) >= me.Length)				return null;			else				return new string(me[index], 1);	')	public static function charAt(me:NativeString, index:Int):NativeString	{		return null;	}		@:functionBody('			if ( ((uint) index) >= me.Length)				return default(Haxe.Lang.Null<int>);			else				return new Haxe.Lang.Null<int>((int)me[index], true);	')	public static function charCodeAt(me:NativeString, index:Int):Null<Int>	{		return null;	}		@:functionBody('			uint sIndex = (startIndex.hasValue) ? ((uint) startIndex.@value) : 0;			if (sIndex >= me.Length)				return -1;			return me.IndexOf(str, (int)sIndex);	')	public static function indexOf(me:NativeString, str:NativeString, ?startIndex:Int):Int	{		return -1;	}		@:functionBody('			int sIndex = (startIndex.hasValue) ? (startIndex.@value) : (me.Length - 1);			if (sIndex > me.Length)				sIndex = me.Length - 1;			else if (sIndex < 0)				return -1;			return me.LastIndexOf(str, sIndex);	')	public static function lastIndexOf(me:NativeString, str:NativeString, ?startIndex:Int):Int	{		return -1;	}		@:functionBody('			string[] native = me.Split(new string[] { delimiter }, System.StringSplitOptions.None);			return new Array<object>(native);	')	public static function split(me:NativeString, delimiter:NativeString):Array<NativeString>	{		return null;	}		@:functionBody('			int meLen = me.Length;			int targetLen = meLen;			if (len.hasValue)			{				targetLen = len.@value;				if (targetLen == 0)					return "";				if( pos != 0 && targetLen < 0 ){					return "";				}			}						if( pos < 0 ){				pos = meLen + pos;				if( pos < 0 ) pos = 0;			} else if( targetLen < 0 ){				targetLen = meLen + targetLen - pos;			}			if( pos + targetLen > meLen ){				targetLen = meLen - pos;			}			if ( pos < 0 || targetLen <= 0 ) return "";						return me.Substring(pos, targetLen);	')	public static function substr(me:NativeString, pos:Int, ?len:Int):NativeString	{		return null;	}		@:functionBody('			return me.ToLower();	')	public static function toLowerCase(me:NativeString):NativeString	{		return null;	}		@:functionBody('			return me.ToUpper();	')	public static function toUpperCase(me:NativeString):NativeString	{		return null;	}		public static function toNativeString(me:NativeString):NativeString	{		return me;	}		@:functionBody('			return new string( (char) code, 1 );	')	public static function fromCharCode(code:Int):NativeString	{		return null;	}}@:keep class StringRefl{	private var target:NativeString;		public var length(default, null) : Int;		public function new(target:NativeString)	{		this.target = target;		this.length = target.length;	}		public function charAt( index : Int ) : NativeString	{		return StringExt.charAt(target, index);	}		public function charCodeAt( index : Int ) : Null<Int>	{		return StringExt.charCodeAt(target, index);	}		public function indexOf( str : NativeString, ?startIndex : Int=0 ) : Int	{		return StringExt.indexOf(target, str, startIndex);	}		public function lastIndexOf( str : NativeString, ?startIndex : Int=-1 ) : Int	{		if (startIndex == -1) startIndex = length;		return StringExt.lastIndexOf(target, str, startIndex);	}		public function split( delimiter : NativeString ) : Array<NativeString>	{		return StringExt.split(target, delimiter);	}		public function substr( pos : Int, ?len : Int=-1 ) : NativeString	{		if (len == -1) len = length;		return StringExt.substr(target, pos, len);	}		public function toLowerCase() : NativeString	{		return StringExt.toLowerCase(target);	}		public function toString() : NativeString	{		return target;	}		public function toUpperCase() : NativeString	{		return StringExt.toUpperCase(target);	}		public static function fromCharCode( code : Int ) : NativeString	{		return StringExt.fromCharCode(code);	}}