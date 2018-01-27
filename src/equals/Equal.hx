package equals;

import haxe.ds.Map;
import haxe.ds.EnumValueMap;
import haxe.ds.IntMap;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;
import haxe.EnumTools.EnumValueTools;

class Equal {

	static function isNull (a:Dynamic) : Bool {
		return switch (Type.typeof(a)) {
			case TNull: true;
			default: false;
		}
	}

	static function isMap(a:Dynamic) : Bool {
		return Std.is(a, Map) || Std.is(a, IntMap) || Std.is(a, StringMap) || Std.is(a, ObjectMap) || Std.is(a, EnumValueMap);
	}

	public static function equals<T> (a:T, b:T) : Bool {
		if (a == b) { return true; } // if physical equality
		if (isNull(a) ||  isNull(b)) {
			return false;
		}

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

		if (isMap(a)) {
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

		if (Reflect.isEnumValue(a)) {
			if (EnumValueTools.getIndex(cast a) != EnumValueTools.getIndex(cast b)) { return false; }
			var a_args = EnumValueTools.getParameters(cast a);
			var b_args = EnumValueTools.getParameters(cast b);
			return equals(a_args, b_args);
		}

		for (field in Reflect.fields(a)) {
			if (Reflect.isFunction(field)) {
				continue;
			}
			if (!equals(Reflect.getProperty(a, field), Reflect.getProperty(b, field))) {
				return false;
			}
			return true;
		}

		return false;
	}
}
