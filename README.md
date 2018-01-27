# equals - Deep equality for Haxe

## Installation

```
haxelib install equals
```

## Usage

```haxe
using equals.Equal

class Main {
	public static function main () {
		var a = [1, 3, 5];
		var b = [1, 4, 5];
		var c = [1, 3, 5, 7];
		var c = [1, 3, 5];
		trace(a.equals(b)); // false
		trace(a.equals(c)); // false
		trace(a.equals(d)); // true
	}
}
```
