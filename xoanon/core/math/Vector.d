module xoanon.core.math.Vector;

import tango.math.Math;

template tComponents(T, int t)
{
	static if(t == 0)
	{
		
	}
	static if(t >= 1)
		public T x;
	static if(t >= 2)
		public T y;
	static if(t >= 3)
		public T z;
	static if(t >= 4)
		public T w;
}

template tVector(T, int t, alias type)
{
	alias type vector;
	
	union
	{
		public T[t] vec;
		struct
		{
			public mixin tComponents!(T, t);
		}
	}
	
	/**
	 * Creates a new vector.
	 * Params:
	 *     components = The components of the vector.
	 * Returns:
	 * The new vector.
	 * Remarks:
	 * The length of the components must be smaller or equal t.
	 */
	public static vector opCall(T[] components...)
	in
	{
		assert(components.length <= t, "Too many components!");
	}
	body
	{
		vector res;
		res.vec[0 .. components.length] = components[];
		return res;
	}
	
	public vector opAdd(vector other)
	{
		vector res;
		res.vec[] = this.vec[] + other.vec[];
		return res;
	}
	
	public vector opAdd(T other)
	{
		vector res;
		res.vec[] = this.vec[] + other;
		return res;
	}
	
	public void opAddAssign(vector other)
	{
		this.vec[] += other.vec[];
	}
	
	public void opAddAssign(T other)
	{
		this.vec[] += other;
	}
	
	public vector opSub(vector other)
	{
		vector res;
		res.vec[] = this.vec[] - other.vec[];
		return res;
	}
	
	public vector opSub(T other)
	{
		vector res;
		res.vec[] = this.vec[] - other;
		return res;
	}
	
	public void opSubAssign(vector other)
	{
		this.vec[] -= other.vec[];
	}
	
	public void opSubAssign(T other)
	{
		this.vec[] -= other;
	}
	
	public T opMul(vector other)
	{
		T res = cast(T) 0;
		vector temp;
		temp.vec[] = this.vec[] * other.vec[];
		for(size_t i = 0; i < temp.vec.length; i++)
		{
			res += temp.vec[i];
		}
		return res;
	}
	
	public vector opMul(T other)
	{
		vector res;
		res.vec[] = this.vec[] * other;
		return res;
	}
	
	public void opMulAssign(T other)
	{
		this.vec[] *= other;
	}
	
	
	public vector opDiv(T other)
	{
		vector res;
		res.vec[] = this.vec[] / other;
		return res;
	}
	
	public void opDivAssign(T other)
	{
		this.vec[] /= other;
	}
	
	/// Negates the vector.
	public final void negate()
	{
		this.vec[] *= -1;
	}
	
	/**
	 * Calculates the squared length.
	 * Returns:
	 * The length of the vector.
	 */
	public final T squaredlength()
	{
		T res = cast(T) 0;
		vector temp;
		temp.vec[] = this.vec[] * this.vec[];
		for(size_t i = 0; i < temp.vec.length; i++)
			res += temp.vec[i];
		return res;
	}
	
	/**
	 * Calculates the length.
	 * Returns:
	 * The length of the vector.
	 */
	public final T length()
	{
		return cast(T)(sqrt(cast(real) this.squaredlength()));
	}
	
	/// Normalizes the vector.
	public final void normalize()
	{
		*this /= this.length;
	}
	
	/// Returns a normalized copy of the vector.
	public final vector normalized()
	{
		vector res;
		res = *this / this.length;
		return res;
	}
	
	/**
	 * Performs a piecewise vector multiplication.
	 * Params:
	 *     a = The first vector.
	 *     b = The second vector.
	 * Returns:
	 * The calculated vector.
	 */
	public static vector Multiply(vector a, vector b)
	{
		vector res;
		res.vec[] = a.vec[] * b.vec[];
		return res;
	}
	/+
	/**
	 * Performs a piecewise vector division.
	 * Params:
	 *     a = The first vector.
	 *     b = The second vector.
	 * Returns:
	 * The calculated vector.
	 */
	public static vector Divide(vector a, vector b)
	{
		vector res;
		res.vec[] = a.vec[] / b.vec[];
		return res;
	}
	+/
	/**
	 * Calculates the dot product.
	 * Params:
	 *     a = The first vector.
	 *     b = The second vector.
	 * Returns:
	 * The dot product of the two vectors.
	 */
	public static T dot(vector a, vector b)
	{
		return (a * b);
	}
	
	public static vector normalize(vector a)
	{
		return a.normalized();
	}
	
	public static T sum(vector a, vector b)
	{
		T res = cast(T) 0;
		vector temp;
		temp.vec[] = a.vec[] * b.vec[];
		for(size_t i = 0; i < temp.vec.length; i++)
			res += temp.vec[i];
		return res;
	}
	
	/**
	 * Converts the vector to an array.
	 * Returns:
	 * The vector as an array.
	 */
	public T[] toArray()
	{
		return this.vec;
	}
	
}

/**
 * A struct template which handles common vector operations.
 * 
 * Params:
 * 		T = The type of the vector.
 * 		t = The size of the vector.
 */
public struct Vector(T, int t)
{
	mixin tVector!(T, t, Vector);
}


public struct Vector(T, int t : 2u)
{
	mixin tVector!(T, t, Vector);
	
	const
	{
		///A vector with all component set to zero.
		public static vector zero;
		///A vector with all component set to one.
		public static vector one;
		///A vector pointing right (1/0).
		public static vector right;
		///A vector pointing left (-1/0).
		public static vector left;
		///A vector pointing up (0/1).
		public static vector up;
		///A vector pointing down (0/-1).
		public static vector down;
	}
	
	static this()
	{
		zero 	= vector(0,0);
		one 	= vector(1,1);
		right 	= vector(1,0);
		left 	= vector(-1,0);
		up 		= vector(0,1);
		down  	= vector(0,-1);
	}
}

/+ doesn't work
///A vector with two $(D_KEYWORD float) components. 
alias Vector2!(float)	Vector2f;
///A vector with two $(D_KEYWORD double) components. 
alias Vector2!(double)	Vector2d;
///A vector with two $(D_KEYWORD real) components. 
alias Vector2!(real)	Vector2r;
+/

public struct Vector(T, int t : 3)
{
	mixin tVector!(T, t, Vector);
	
	const
	{
		///A vector with all component set to zero.
		public static vector zero;
		///A vector with all component set to one.
		public static vector one;
		///A vector pointing right (1/0/0).
		public static vector right;
		///A vector pointing left (-1/0/0).
		public static vector left;
		///A vector pointing up (0/1/0).
		public static vector up;
		///A vector pointing down (0/-1/0).
		public static vector down;
		///A vector pointing forward (0/0/1).
		public static vector forward;
		///A vector pointing backward (0/0/-1).
		public static vector backward;
	}
	
	static this()
	{
		zero 	= vector(0,0,0);
		one 	= vector(1,1,1);
		right 	= vector(1,0,0);
		left 	= vector(-1,0,0);
		up 		= vector(0,1,0);
		down  	= vector(0,-1,0);
		forward = vector(0,0,1);
		backward= vector(0,0,-1);
		
	}
	
	public vector opMod(vector other)
	{
		vector res;
		res.x = this.y * other.z - this.z * other.y; 
		res.y = this.z * other.x - this.x * other.z;
		res.z = this.x * other.y - this.y * other.x;
		return res;
	}
	
	/**
	 * Calculates the cross product.
	 * Params:
	 *     a = The first vector.
	 *     b = The second vector.
	 * Returns:
	 * The cross product of the two vectors.
	 */
	public static vector cross(vector a, vector b)
	{
		return (a % b);
	}
}

public struct Vector(T, int t : 4)
{
	mixin tVector!(T, t, Vector);
	
	const
	{
		///A vector with all component set to zero.
		public static vector zero;
		///A vector with all component set to one.
		public static vector one;
	}
	
	static this()
	{
		zero 	= vector();
		one 	= vector(1,1,1,1);
	}
}

alias Vector!(float, 2) Vector2f; 
alias Vector!(float, 3) Vector3f;
alias Vector!(float, 4) Vector4f;

alias Vector!(double, 2) Vector2d; 
alias Vector!(double, 3) Vector3d;
alias Vector!(double, 4) Vector4d;