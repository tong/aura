package aura.types;

import haxe.ds.Vector;

import kha.FastFloat;

@:forward(length)
@:unreflective
abstract ComplexArray(Vector<Complex>) {
	/**
		Create a new zero-initialized complex array.
	**/
	public inline function new(length: Int) {
		this = new Vector<Complex>(length);
		for (i in 0...length) {
			this[i] = Complex.newZero();
		}
	}

	@:arrayAccess
	public inline function get(index: Int): Complex {
		return this[index];
	}

	@:arrayAccess
	public inline function set(index: Int, value: Complex): Complex {
		// Copy to array to keep original value on stack
		this[index].setFrom(value);
		return this[index];
	}
}

@:notNull
@:pure
@:unreflective
@:forward(real, imag)
abstract Complex(ComplexImpl) {
	public inline function new(real: FastFloat, imag: FastFloat) {
		this = new ComplexImpl(real, imag);
	}

	@:from
	public static inline function fromReal(real: FastFloat): Complex {
		return new Complex(real, 0.0);
	}

	public static inline function newZero(): Complex {
		return new Complex(0.0, 0.0);
	}

	public inline function copy(): Complex {
		return new Complex(this.real, this.imag);
	}

	public inline function setZero() {
		this.real = this.imag = 0.0;
	}

	public inline function setFrom(other: Complex) {
		this.real = other.real;
		this.imag = other.imag;
	}

	public inline function scale(s: FastFloat) {
		this.real *= s;
		this.imag *= s;
	}

	public static inline function exp(w: FastFloat) {
		return new Complex(Math.cos(w), Math.sin(w));
	}

	@:op(A + B)
	public inline function add(other: Complex): Complex {
		return new Complex(this.real + other.real, this.imag + other.imag);
	}

	@:op(A - B)
	public inline function sub(other: Complex): Complex {
		return new Complex(this.real - other.real, this.imag - other.imag);
	}

	@:op(A * B)
	@:commutative
	public inline function mult(other: Complex): Complex {
		return new Complex(
			this.real*other.real - this.imag*other.imag,
			this.real*other.imag + this.imag*other.real
		);
	}

	@:op(~A)
	public inline function conj(): Complex {
		return new Complex(this.real, -this.imag);
	}

	@:op(A == B)
	public inline function eq(other: Complex): Bool {
		return this.real == other.real && this.imag == other.imag;
	}
}

@:pure
@:notNull
@:unreflective
@:struct
class ComplexImpl {
	public var real: FastFloat;
	public var imag: FastFloat;

	public inline function new(real:FastFloat, imag: FastFloat) {
		this.real = real;
		this.imag = imag;
	}
}