package tests;

import utest.Assert;
import utest.Runner;
import utest.ui.Report;

using equals.Equal;

enum A {
	I;
	T;
	S(a:Int);
}

class Cls {
	public var a = 1;
	public var b = false;
	public var c = {a:false};
	public function new() {}
}

enum B {
	TA(e:Bool);
	TB(e:Int);
}

abstract Abs(Array<Int>) {
	public function new(a) { this = a; }
}

class Test {
	public function new() {}

	public function testAll () {
		Assert.isFalse([1].equals([1,3]));
		Assert.isTrue([1].equals([1]));
		Assert.isFalse([1=>2, 3=>4].equals([1=>2]));
		Assert.isTrue([1=>2, 3=>4].equals([1=>2, 3=>4]));
		Assert.isFalse(A.I.equals(A.T));
		Assert.isTrue(A.T.equals(A.T));
		Assert.isFalse(A.S(1).equals(A.S(2)));
		Assert.isTrue(A.S(1).equals(A.S(1)));

		 var a = {
			a:[1, 2, 3],
			b:[1=>3, 2=>4],
			c:{a:new Cls(), c:B.TA(true)}
		};

		 var b = {
			a:[1, 2, 3],
			b:[1=>3, 2=>4],
			c:{a:new Cls(), c:B.TA(true)}
		};
		Assert.isTrue(a.equals(b));
		b.b = null;
		Assert.isFalse(a.equals(b));

		var c = new Abs([1, 2, 3]);
		var d = new Abs([2, 3, 1]);
		var e = new Abs([1, 2, 3]);
		Assert.isFalse(c.equals(d));
		Assert.isTrue(c.equals(e));

		var t1 = {f:function() { trace(1); }};
		var t2 = {f:function() { trace(2); }};
		var t3 = {f:null};
		var t4 = {f:null};
		Assert.isTrue(t1.equals(t2));
		Assert.isFalse(t1.equals(t3));
		Assert.isTrue(t3.equals(t4));
	}

	public static function main () {
		var allOk = true;
		var runner = new Runner();
		runner.addCase(new Test());
		runner.onProgress.add(function (result) {
			allOk = allOk && result.result.allOk();
		});
		Report.create(runner);
		runner.run();
		#if sys
		Sys.exit(allOk ? 0 : 1);
		#end
	}
}
