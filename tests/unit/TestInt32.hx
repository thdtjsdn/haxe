package unit;
import haxe.Int32;
using haxe.Int32;

class TestInt32 extends Test {

	static inline function i( x ) {
		return Int32.toInt(x);
	}

	static inline function i32( x ) {
		return Int32.ofInt(x);
	}

	public function test() {
		// constants
		eq( 0xFE08BE39, -32981447 );

		var one = i32(1);
		var minone = i32(-1);
		var zero = i32(0);

		// ofInt / make
		eq( i(zero), 0 );
		eq( i(one), 1 );
		eq( i(minone), -1 );
		eq( i(i32(0x01020304)), 0x01020304 );
		eq( i(Int32.make(0x0102, 0x0304)), 0x01020304 );
		eq( i(Int32.make(0x10102, 0x0304)), 0x01020304 );

		// 31 bits overflow
		exc( function() i(Int32.shl(one,30)) );
		exc( function() i(Int32.shl(i32(2),30)) );
		exc( function() i(Int32.neg(Int32.add(Int32.shl(one,30),one))) );

		// check correct closure creation (not inlined)
		var f = Int32.make;
		eq( i(f(0x0102,0x0304)), 0x01020304 );

		eq( Int32.compare(one,one), 0 );
		eq( Int32.compare(one,zero), 1 );
		eq( Int32.compare(zero,one), -1 );
		eq( Int32.compare(minone,minone), 0 );
		eq( Int32.compare(minone,zero), -1 );
		eq( Int32.compare(zero,minone), 1 );

		eq( Int32.ucompare(one,one), 0 );
		eq( Int32.ucompare(one,zero), 1 );
		eq( Int32.ucompare(zero,one), -1 );
		eq( Int32.ucompare(minone,minone), 0 );
		eq( Int32.ucompare(minone,zero), 1 );
		eq( Int32.ucompare(zero,minone), -1 );
		eq( Int32.ucompare((-1).ofInt(),(-2).ofInt()), 1 );
		eq( Int32.ucompare((-2).ofInt(),(-1).ofInt()), -1 );


		eq( i(Int32.add(one,one)), 2 );
		eq( i(Int32.sub(minone,one)), -2 );
		eq( i(Int32.mul(i32(5),i32(100))), 500 );

		// overflow
		eq( i(Int32.mul(i32(160427), i32(160427))), 0xFE08BE39 );
		
		// float overflow
		eq( i(Int32.mul(f(0x811C,0x9DAE), i32(16777619))), -301188886 );

		// signed divide and modulo
		eq( i(Int32.div(i32(0x3E08BE39),i32(16))), 0x03E08BE3 );
		eq( i(Int32.div(i32(0xFE08BE39),i32(16))), 0xFFE08BE4 );
		eq( i(Int32.mod(i32(0xFE08BE39),i32(0xFFFF))), -17342 );
		eq( i(Int32.mod(i32(0xE08BE39),i32(0x10000))), 0xBE39 );

		// logical
		eq( i(Int32.shl(i32(5),16)), 0x50000 );
		eq( i(Int32.shl(i32(3),30)), 0xC0000000 );
		eq( i(Int32.shr(i32(-1),16)), -1 );
		eq( i(Int32.ushr(i32(-1),16)), 0xFFFF );

		eq( i(Int32.and(i32(0xFE08BE39),i32(0xFFFF))), 0xBE39 );
		eq( i(Int32.and(i32(0xFE08BE39),i32(0xFFFF0000))), 0xFE080000 );
		eq( i(Int32.and(i32(0xFE08BE39),i32(0xFFF0000))), 0x0E080000 );

		eq( i(Int32.or(i32(0xFE08BE39),i32(0xFFFF))), 0xFE08FFFF );
		eq( i(Int32.or(i32(0xFE08BE39),i32(0xFFFF0000))), 0xFFFFBE39 );
		eq( i(Int32.or(i32(0xBE39),i32(0xFE080000))), 0xFE08BE39 );

		eq( i(Int32.xor(i32(0xFE08BE39),i32(0xCBCDEF99))), 0x35C551A0 );
		eq( i(Int32.neg(one)), -1 );
		eq( i(Int32.complement(i32(55))), -56 );
		eq( i(Int32.complement(i32( -0x10000))), 0xFFFF );

		// check overflows
		eq( i(i32((1 << 29) * 255)), 0xE0000000 );

		eq( 0x050BCDEF.ofInt().shl(8).ushr(8).toInt(), 0x0BCDEF );

		eq( 0x050BCDEF.ofInt().shl(8).div(256.ofInt()).toInt(), 0x0BCDEF );

		eq( 7.ofInt().div(3.ofInt()).mul(3.ofInt()).toInt(), 6 );

		eq( 0x050BCDEF.ofInt().mul(256.ofInt()).mod(0xFF.ofInt()).toInt(), 200 );

		// bit shifts are % 32
		
		eq( i(i32(5).shl(0)), 5 );
		eq( i(i32(5).shr(0)), 5 );
		eq( i(i32(5).ushr(0)), 5 );

		eq( i(i32(5).shl(32)), 5 );
		eq( i(i32(5).shr(32)), 5 );
		eq( i(i32(5).ushr(32)), 5 );

		eq( i(i32(5).shl(33)), 10 );
		eq( i(i32(5).shr(33)), 2 );
		eq( i(i32(5).ushr(33)), 2 );
		
		eq( i(i32(5).shl(-5)), 671088640 );
		eq( i(i32(5).shr(-31)), 2 );
		eq( i(i32(5).ushr(-31)), 2 );
		
	}

}