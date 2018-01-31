package equals;

import haxe.EnumTools.EnumValueTools;

class Equal {

	static function isNull (a:Dynamic) : Bool {
		return switch (Type.typeof(a)) {
			case TNull: true;
			default: false;
		}
	}

	static function isFunction(a:Dynamic) : Bool {
		return switch (Type.typeof(a)) {
			case TFunction: true;
			default: false;
		}
	}

	public static function equals<T> (a:T, b:T) : Bool {
		if (a == b) { return true; } // if physical equality
		if (isNull(a) ||  isNull(b)) {
			return false;
		}

		switch (Type.typeof(a)) {
			case TNull, TInt, TBool, TUnknown:
				return a == b; // shall not be reached
			case TFloat:
				return Math.isNaN(cast a) && Math.isNaN(cast b); // only valid true result remaining
			case TFunction:
				return Reflect.compareMethods(a, b); // only physical equality can be tested for function
			case TEnum(_):
				if (EnumValueTools.getIndex(cast a) != EnumValueTools.getIndex(cast b)) {
					return false;
				}
				var a_args = EnumValueTools.getParameters(cast a);
				var b_args = EnumValueTools.getParameters(cast b);
				return equals(a_args, b_args);
			case TClass(_):
				if (Std.is(a, Array)) {
					var a = cast(a, Array<Dynamic>);
					var b = cast(b, Array<Dynamic>);
					if (a.length != b.length) { return false; }
					for (i in 0...a.length) {
						if (!equals(a[i], b[i])) {
							return false;
						}
					}
					return true;
				}

				if (Std.is(a, haxe.Constraints.IMap)) {
					var a = cast(a, Map<Dynamic, Dynamic>);
					var b = cast(b, Map<Dynamic, Dynamic>);
					var a_keys = [ for (key in a.keys()) key ];
					var b_keys = [ for (key in b.keys()) key ];
					if (!equals(a_keys, b_keys)) { return false; }
					for (key in a_keys) {
						if (!equals(a.get(key), b.get(key))) {
							return false;
						}
					}
					return true;
				}

				if (Std.is(a, Date)) {
					return cast(a, Date).getTime() == cast(b, Date).getTime();
				}

				if (Std.is(a, haxe.io.Bytes)) {
					return equals(cast(a, haxe.io.Bytes).getData(), cast(b, haxe.io.Bytes).getData());
				}

			case TObject:
		}

		for (field in Reflect.fields(a)) {
			var pa = Reflect.getProperty(a, field);
			var pb = Reflect.getProperty(b, field);
			if (isFunction(pa)) {
				// ignore function as only physical equality can be tested, unless null
				if (isNull(pa) != isNull(pb)) {
					return false;
				}
				continue;
			}
			if (!equals(pa, pb)) {
				return false;
			}
		}

		return true;
	}
}
