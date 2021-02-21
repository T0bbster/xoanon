module xoanon.core.math.Quaternion;

import xoanon.core.math.Matrix;
import xoanon.core.math.Vector;
import tango.math.Math;

struct Quaternion(T)
{
	private alias Quaternion!(T) quaternion;
	private alias Vector!(T, 3) vector3;
	
	union
	{
		public vector3 vector;
		struct
		{
			public T x;
			public T y;
			public T z;
		}
	}
	union
	{
		public T scalar;
		public T w;
	}
	
	static quaternion identity;
	
	static this()
	{
		identity = quaternion(0, 0, 0, 1);
	}
	
	public static quaternion opCall(vector3 vector, T scalar)
	{
		quaternion res;
		res.vector = vector;
		res.scalar = scalar;
		return res;
	}
	
	public static quaternion opCall(T x, T y, T z, T w)
	{
		quaternion res;
		res.x = x;
		res.y = y;
		res.z = z;
		res.w = w;
		return res;
	}
	
	public quaternion opAdd(quaternion other)
	{
		quaternion res;
		res.vector = this.vector + other.vector;
		res.scalar = this.scalar + other.scalar;
		return res;
	}
	
	public void opAddAssign(quaternion other)
	{
		this.vector += other.vector;
		this.scalar += other.scalar;
	}
	
	public quaternion opSub(quaternion other)
	{
		quaternion res;
		res.vector = this.vector - other.vector;
		res.scalar = this.scalar - other.scalar;
		return res;
	}
	
	public void opSubAssign(quaternion other)
	{
		this.vector -= other.vector;
		this.scalar -= other.scalar;
	}
	
	public quaternion opMul(quaternion other)
	{
		quaternion res;
		res.vector = this.vector % other.vector + other.w * this.vector + this.w * other.vector;
		res.scalar = this.w * other.w - this.vector * other.vector;
		return res;
	}
	
	public quaternion opMul(T other)
	{
		quaternion res;
		res.vector = other * this.vector;
		res.scalar = other * this.scalar;
		return res;
	}
	
	public void opMulAssign(quaternion other)
	{
		*this = *this * other; 
	}
	
	public void opMulAssign(T other)
	{
		*this = *this * other; 
	}
	
	public quaternion conjugate()
	{
		quaternion res;
		res.vector = this.vector * -1;
		res.scalar = this.scalar;
		return res;
	}
	
	public T squaredLength()
	{
		return this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w;
	}
	
	public T length()
	{
		return sqrt(this.squaredLength());
	}
	
	public void invert()
	{
		*this = this.inverse();
	}
	
	public quaternion inverse()
	{
		quaternion res;
		res = cast(T) 1 / this.squaredLength() * this.conjugate;
		return res;
	}
	
	public static quaternion createFromAxisAngle(vector3 axis, T angle)
	{
		quaternion res;
		angle = angle / cast(T) 2;
		T temp = sin(angle);
		
		res.vector = axis * temp;
		res.scalar = cos(angle);
		return res;
	}
	
	public vector3 transform(vector3 point)
	{
		quaternion p = quaternion(point, 1);
		return ((*this * p) * this.conjugate).vector;
	}
	
	public Matrix!(T, 4, 4) toMatrix()
	{
		T s = cast(T) 2.0 / this.length;
		Matrix4f res;
		with(*this)
		{
			res = Matrix4f(	1 - s*(y*y + z*z), 	s*(x*y - w*z), 		s*(x*z), 			0,
							s*(x*y + w*z),		1 - s*(x*x + z*z),	s*(y*z - w*x),		0,
							s*(x*z - w*y),		s*(y*z + w*x),		1 - s*(x*x + y*y),	0,
							0,					0,					0,					1);
		}
		return res;
	}
	
	public void setMatrix(Matrix!(T, 4, 4) matrix)
	{
		//TODO
	}
}